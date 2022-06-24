import SwiftUI

struct StorybookColors {

    @ViewBuilder static var storybook: some View {
        product
        Icon
        white
        cloud
        ink
    }

    @ViewBuilder static var storybookStatus: some View {
        green
        red
        orange
        blue
    }

    @ViewBuilder static var storybookGradient: some View {
        bundle
    }

    @ViewBuilder static var product: some View {
        Card("Product", borderStyle: .default, contentLayout: .fill) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    color(.productLight, label: "Product Light")
                }
                HStack(spacing: 0) {
                    color(.productNormal, label: "Product Normal")
                }
                HStack(spacing: 0) {
                    color(.productDark, label: "Product Dark")
                }
                color(.productDarker, label: "Product Darker")
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var Icon: some View {
        Card("Icon", borderStyle: .default, contentLayout: .fill) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    color(.iconPrimary, label: "Icon Primary")
                }
                HStack(spacing: 0) {
                    color(.iconSecondary, label: "Icon Secondary")
                }
                HStack(spacing: 0) {
                    color(.iconTertiary, label: "Icon Tertiary")
                }
            }
        }
        .padding(.medium)
    }
    
    @ViewBuilder static var white: some View {
        Card("White", borderStyle: .default, contentLayout: .fill) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    color(.whiteNormal, label: "White")
                    color(.whiteHover, label: "White: hover")
                    color(.whiteActive, label: "White: active")
                }
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var cloud: some View {
        Card("Cloud", borderStyle: .default, contentLayout: .fill) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    color(.cloudLight, label: "Cloud Light")
                    color(.cloudLightHover, label: "Cloud Light: hover")
                    color(.cloudLightActive, label: "Cloud Light: active")
                }
                HStack(spacing: 0) {
                    color(.cloudNormal, label: "Cloud Normal")
                    color(.cloudNormalHover, label: "Cloud Normal: hover")
                    color(.cloudNormalActive, label: "Cloud Normal: active")
                }
                color(.cloudDark, label: "Cloud Dark")
                HStack(spacing: 0) {
                    color(.cloudDarker, label: "Cloud Darker")
                    color(.cloudDarkerHover, label: "Cloud Darker: hover")
                    color(.cloudDarkerActive, label: "Cloud Darker: active")
                }
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var ink: some View {
        Card("Ink", borderStyle: .default, contentLayout: .fill) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    color(.inkLighter, label: "Ink Lighter")
                    color(.inkLighterHover, label: "Ink Lighter: hover")
                    color(.inkLighterActive, label: "Ink Lighter: active")
                }
                HStack(spacing: 0) {
                    color(.inkLight, label: "Ink Light")
                    color(.inkLightHover, label: "Ink Light: hover")
                    color(.inkLightActive, label: "Ink Light: active")
                }
                HStack(spacing: 0) {
                    color(.inkNormal, label: "Ink Normal")
                    color(.inkNormalHover, label: "Ink Normal: hover")
                    color(.inkNormalActive, label: "Ink Normal: active")
                }
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var green: some View {
        Card("Green", borderStyle: .default, contentLayout: .fill) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    color(.greenLight, label: "Green Light")
                    color(.greenLightHover, label: "Green Light: hover")
                    color(.greenLightActive, label: "Green Light: active")
                }
                HStack(spacing: 0) {
                    color(.greenNormal, label: "Green Normal")
                    color(.greenNormalHover, label: "Green Normal: hover")
                    color(.greenNormalActive, label: "Green Normal: active")
                }
                HStack(spacing: 0) {
                    color(.greenDark, label: "Green Dark")
                    color(.greenDarkHover, label: "Green Dark: hover")
                    color(.greenDarkActive, label: "Green Dark: active")
                }
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var orange: some View {
        Card("Orange", borderStyle: .default, contentLayout: .fill) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    color(.orangeLight, label: "Orange Light")
                    color(.orangeLightHover, label: "Orange Light: hover")
                    color(.orangeLightActive, label: "Orange Light: active")
                }
                HStack(spacing: 0) {
                    color(.orangeNormal, label: "Orange Normal")
                    color(.orangeNormalHover, label: "Orange Normal: hover")
                    color(.orangeNormalActive, label: "Orange Normal: active")
                }
                HStack(spacing: 0) {
                    color(.orangeDark, label: "Orange Dark")
                    color(.orangeDarkHover, label: "Orange Dark: hover")
                    color(.orangeDarkActive, label: "Orange Dark: active")
                }
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var red: some View {
        Card("Red", borderStyle: .default, contentLayout: .fill) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    color(.redLight, label: "Red Light")
                    color(.redLightHover, label: "Red Light: hover")
                    color(.redLightActive, label: "Red Light: active")
                }
                HStack(spacing: 0) {
                    color(.redNormal, label: "Red Normal")
                    color(.redNormalHover, label: "Red Normal: hover")
                    color(.redNormalActive, label: "Red Normal: active")
                }
                HStack(spacing: 0) {
                    color(.redDark, label: "Red Dark")
                    color(.redDarkHover, label: "Red Dark: hover")
                    color(.redDarkActive, label: "Red Dark: active")
                }
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var blue: some View {
        Card("Blue", borderStyle: .default, contentLayout: .fill) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    color(.blueLight, label: "Blue Light")
                    color(.blueLightHover, label: "Blue Light: hover")
                    color(.blueLightActive, label: "Blue Light: active")
                }
                HStack(spacing: 0) {
                    color(.blueNormal, label: "Blue Normal")
                    color(.blueNormalHover, label: "Blue Normal: hover")
                    color(.blueNormalActive, label: "Blue Normal: active")
                }
                HStack(spacing: 0) {
                    color(.blueDark, label: "Blue Dark")
                    color(.blueDarkHover, label: "Blue Dark: hover")
                    color(.blueDarkActive, label: "Blue Dark: active")
                }
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static var bundle: some View {
        Card("Bundle", borderStyle: .default, contentLayout: .fill) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    gradient(.bundleBasic, label: "Bundle Basic")
                    HStack(spacing: 0) {
                        color(.bundleBasicStart, label: "Bundle Basic: start")
                        color(.bundleBasicEnd, label: "Bundle Basic: end")
                    }
                }
                HStack(spacing: 0) {
                    gradient(.bundleMedium, label: "Bundle Medium")
                    HStack(spacing: 0) {
                        color(.bundleMediumStart, label: "Bundle Medium: start")
                        color(.bundleMediumEnd, label: "Bundle Medium: end")
                    }
                }
                HStack(spacing: 0) {
                    gradient(.bundleTop, label: "Bundle Top")
                    HStack(spacing: 0) {
                        color(.bundleTopStart, label: "Bundle Top: start")
                        color(.bundleTopEnd, label: "Bundle Top: end")
                    }
                }
            }
        }
        .padding(.medium)
    }

    @ViewBuilder static func color(_ color: UIColor, label: String) -> some View {
        Color(color)
            .frame(height: 80)
            .overlay(
                Text(
                    label,
                    size: .small,
                    color: .custom(color.brightness > 0.6 ? .inkNormal : .whiteNormal),
                    weight: .medium
                )
                .padding(.horizontal, .medium)
                .padding(.vertical, .small),
                alignment: .topLeading
            )
    }

    @ViewBuilder static func gradient(_ gradient: Gradient, label: String) -> some View {
        gradient.background
            .frame(height: 80)
            .overlay(
                Text(
                    label,
                    size: .small,
                    color: .white,
                    weight: .medium
                )
                .padding(.horizontal, .medium)
                .padding(.vertical, .small),
                alignment: .topLeading
            )
    }
}

extension UIColor {

    var brightness: CGFloat {
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getWhite(&brightness, alpha: &alpha)
        return brightness
    }
}

struct StorybookColorsPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            StorybookColors.storybook
            StorybookColors.storybookStatus
            StorybookColors.storybookGradient
        }
        .previewLayout(.sizeThatFits)
    }
}
