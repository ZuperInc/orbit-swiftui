#!/usr/bin/env python3
# encoding: utf-8

"""
This script:
  1) Reads up-to-date color definitions from Orbit API
  2) If running in the check-only mode
    a) Checks if the regenerated file would result in a different content
  3) Else
    a) Regenerates xcassets file with updated color definitions
    b) Regenerates a swift source code that uses that color xcassets file
"""

import sys
import os
import json
import re
import pathlib
import shutil
import colorsys
from urllib.request import urlopen

ORBIT_URL = 'https://unpkg.com/@kiwicom/orbit-design-tokens/output/theo-spec.json'
ORBIT_COLOR_PREFIX = 'palette'

contents_filename = 'Contents.json'

xcassets_header = '''{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
'''

xcassets_color_template = '''{{
  "colors" : [
    {{
      "color" : {{
        "color-space" : "srgb",
        "components" : {{
          "alpha" : "1.000",
          "blue" : "0x{B}",
          "green" : "0x{G}",
          "red" : "0x{R}"
        }}
      }},
      "idiom" : "universal"
    }},
    {{
      "appearances" : [
        {{
          "appearance" : "luminosity",
          "value" : "dark"
        }}
      ],
      "color" : {{
        "color-space" : "srgb",
        "components" : {{
          "alpha" : "1.000",
          "blue" : "0x{iB}",
          "green" : "0x{iG}",
          "red" : "0x{iR}"
        }}
      }},
      "idiom" : "universal"
    }}
  ],
  "info" : {{
    "author" : "xcode",
    "version" : 1
  }}
}}
'''

source_filename_plural = f'Colors'
source_group_template = '\n    // MARK: - {group}'
source_line_template = '    /// Orbit {description} color.\n    static let {name} = Color("{description}", bundle: .current)'
source_line_template_uicolor = '    /// Orbit {description} color.\n    static let {name} = fromResource(named: "{description}")'
source_template = '''import SwiftUI

// Generated by 'Automation/update_colors.py'
public extension Color {{
{colorList}
}}
'''

source_template_uicolor = '''import UIKit

// Generated by 'Automation/update_colors.py'
public extension UIColor {{
{colorList}
}}
'''

def lowercase_first_letter(s):
  return s[:1].lower() + s[1:] if str else ''

def camel_case_split(str):
  return re.findall(r'[A-Z](?:[a-z]+|[A-Z]*(?=[A-Z]|$))', str)

def str_to_hexa(str):
  return '{0:0{1}x}'.format(int(str),2).upper()

def get_inversed_colors(name, colors):

  inverted_base = None
  predefined_light = False
  predefined_lighter = False
  predefined_dark = False
  predefined_darker = False

  # Predefined WIP Dark Mode colors
  if name == 'whiteLighter':
    return [0, 0, 0]
  elif name == 'whiteDarker':
    return [31, 42, 55]

  if name.startswith('white'):
    inverted_base = [17, 25, 39]

  if name == 'whiteNormal':
    return inverted_base

  if name.startswith('inkLight'):
    # (too light) inverted_base = [186, 199, 213]
    inverted_base = [128, 152, 178]
    predefined_light = True
  elif name.startswith('ink'):
    inverted_base = [255, 255, 255]

  if name.startswith('product'):
    inverted_base = [0, 203, 174]

  if name.startswith('greenDark'):
    inverted_base = [100, 216, 115]
    predefined_dark = True
  elif name.startswith('greenLight'):
    inverted_base = [37, 75, 60]
    predefined_light = True
  elif name.startswith('green'):
    inverted_base = [59, 206, 78]

  if name.startswith('blueDark'):
    inverted_base = [103, 187, 254]
    predefined_dark = True
  elif name.startswith('blueLight'):
    inverted_base = [33, 66, 95]
    predefined_light = True
  elif name.startswith('blue'):
    inverted_base = [42, 160, 254]

  if name.startswith('orangeDark'):
    inverted_base = [252, 179, 90]
    predefined_dark = True
  elif name.startswith('orangeLight'):
    inverted_base = [75, 66, 54]
    predefined_light = True
  elif name.startswith('orange'):
    inverted_base = [251, 161, 50]

  if name.startswith('redDark'):
    inverted_base = [255, 112, 112]
    predefined_dark = True
  elif name.startswith('redLight'):
    inverted_base = [76, 50, 60]
    predefined_light = True
  elif name.startswith('red'):
    inverted_base = [255, 80, 80]

  if name.startswith('cloudDark') and not name.startswith('cloudDarker'):
    inverted_base = [56, 65, 75]
    predefined_dark = True
  elif name.startswith('cloud'):
    inverted_base = [41, 56, 69]

  # Generate any leftover light/dark variants
  if inverted_base is not None and 'Lighter' in name and not predefined_lighter:
    inverted_base = get_color_with_updated_luminosity(inverted_base, -0.2)
  elif inverted_base is not None and 'Light' in name and not predefined_light:
    inverted_base = get_color_with_updated_luminosity(inverted_base, -0.1)
  elif inverted_base is not None and 'Darker' in name and not predefined_darker:
    inverted_base = get_color_with_updated_luminosity(inverted_base, 0.15)
  elif inverted_base is not None and 'Dark' in name and not predefined_dark:
    inverted_base = get_color_with_updated_luminosity(inverted_base, 0.07)

  # Generate any hover/active variants
  if inverted_base is not None and name.endswith('Hover'):
    inverted_base = get_color_with_updated_luminosity(inverted_base, 0.05)
  elif inverted_base is not None and name.endswith('Active'):
    inverted_base = get_color_with_updated_luminosity(inverted_base, 0.1)

  if inverted_base is not None:
    return inverted_base

  # Invert the rest of colors
  r, g, b = [float(c)/255.0 for c in colors]
  h, l, s = colorsys.rgb_to_hls(r, g, b)
  rgb_inverted = colorsys.hls_to_rgb(h, 1.0 - l, s)
  return [float(c)*255.0 for c in rgb_inverted]

def get_color_with_updated_luminosity(color, luminosity_offset):
  r, g, b = [float(c)/255.0 for c in color]
  h, l, s = colorsys.rgb_to_hls(r, g, b)
  updated_color = colorsys.hls_to_rgb(h, max(0.0, min(1.0, l + luminosity_offset)), s)
  return [float(c)*255.0 for c in updated_color]

def get_updated_colors():
  r = urlopen(ORBIT_URL).read()
  data = json.loads(r)
  return {k: v for k, v in data.items() if k.startswith(ORBIT_COLOR_PREFIX)}

def isRunningInCheckOnlyMode():
  return "--check-only" in sys.argv

def colorsFolderPath():
  if len(sys.argv) > 1 and not sys.argv[1].startswith('-'):
    colorsFolder = pathlib.Path(sys.argv[1])
    assert colorsFolder.exists(), f'Path {colorsFolder} does not exist'
    return colorsFolder
  else:
    # Find color source files folder
    iosRootPath = pathlib.Path(__file__).absolute().parent.parent.parent
    return next(iosRootPath.rglob(f'{source_filename_plural}.swift')).parent

if __name__ == "__main__":

  colors = get_updated_colors()

  # Add lighter (elevated) version of white
  colors['paletteWhiteLighter'] = 'rgb(255, 255, 255)'
  # Add darker (background) version of white
  colors['paletteWhiteDarker'] = 'rgb(255, 255, 255)'

  colorsFolder = colorsFolderPath()
  codePath = colorsFolder.joinpath(f'{source_filename_plural}.swift')
  codePathUIColor = colorsFolder.joinpath(f'UI{source_filename_plural}.swift')
  assetPath = colorsFolder.joinpath(f'{source_filename_plural}.xcassets')

  if not isRunningInCheckOnlyMode():
    # Recreate the xcassets folder
    shutil.rmtree(assetPath, ignore_errors = True)
    assetPath.mkdir(exist_ok = True)

    # Create generic xcassets header
    with open(assetPath.joinpath(contents_filename), "w") as contentsFile:
      contentsFile.write(xcassets_header)

  sourceColorLines = []
  sourceUIColorLines = []
  lastColorGroup = ''

  for key, value in sorted(colors.items()):
      
      # Parse key and value into tokens and hex colors
      key_tokens = camel_case_split(key)
      group = key_tokens[0]
      name = lowercase_first_letter("".join(key_tokens[0:]))

      if name == "white":
        # Workaround for system white color name clash
        name = "whiteNormal"

      description = " ".join(key_tokens[0:])

      colors = re.findall(r'\d+', value)
      assert len(colors) == 3, "Expected 3 decimal RGB values from JSON"
      colors_inverse = get_inversed_colors(name, colors)
      rgb_hex_colors = list(map(lambda c: str_to_hexa(c), colors))
      rgb_hex_inverse_colors = list(map(lambda c: str_to_hexa(c), colors_inverse))

      if group != lastColorGroup:
        sourceColorLines.append(source_group_template.format(group = group))
        sourceUIColorLines.append(source_group_template.format(group = group))
        lastColorGroup = group

      sourceColorLines.append(source_line_template.format(name = name, description = description))
      sourceUIColorLines.append(source_line_template_uicolor.format(name = name, description = description))

      if isRunningInCheckOnlyMode():
        continue

      groupPath = assetPath.joinpath(group)
      colorSetPath = groupPath.joinpath(f'{description}.colorset')

      groupPath.mkdir(exist_ok = True)
      colorSetPath.mkdir(exist_ok = True)

      # Create generic xcassets header
      with open(groupPath.joinpath(contents_filename), "w") as contentsFile:
          contentsFile.write(xcassets_header)

      # Create color definition file
      with open(colorSetPath.joinpath(contents_filename), "w") as colorSetFile:
          colorSetFile.write(xcassets_color_template.format(
            R = rgb_hex_colors[0], G = rgb_hex_colors[1], B = rgb_hex_colors[2],
            iR = rgb_hex_inverse_colors[0], iG = rgb_hex_inverse_colors[1], iB = rgb_hex_inverse_colors[2])
          )

  updatedSourceContent = source_template.format(colorList = '\n'.join(sourceColorLines))
  updatedSourceContentUIColor = source_template_uicolor.format(colorList = '\n'.join(sourceUIColorLines))

  if isRunningInCheckOnlyMode():
    isUpdateAvailable = updatedSourceContent != open(codePath).read() or updatedSourceContentUIColor != open(codePathUIColor).read()
    exitCode = 0

    if isUpdateAvailable:
      exitCode = 1

    sys.exit(exitCode)

  # Recreate the color extensions source file
  with open(codePath, "w") as sourceFile:
      sourceFile.write(updatedSourceContent)

  with open(codePathUIColor, "w") as sourceFile:
      sourceFile.write(updatedSourceContentUIColor)
