import SwiftUI

/// Offers a control to toggle a setting on or off.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/interaction/switch/)
public struct Switch: View {

    public static let size = CGSize(width: 50, height: 28)
    public static let circleDiameter: CGFloat = 30
    public static let dotDiameter: CGFloat = 10
    
    static let borderColor = Color(white: 0.2, opacity: 0.25)
    static let shadowColor: Color = .inkNormal.opacity(0.2)

    @Environment(\.sizeCategory) var sizeCategory
    @Binding private var isOn: Bool

    let hasIcon: Bool
    let isEnabled: Bool

    public var body: some View {
        capsule
            .overlay(indicator)
            .accessibility(addTraits: [.isButton])
            .onTapGesture {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                    isOn.toggle()
                }
            }
            .disabled(isEnabled == false)
    }

    @ViewBuilder var capsule: some View {
        Capsule(style: .circular)
            .frame(width: width, height: height)
            .foregroundColor(tint)
    }

    @ViewBuilder var indicator: some View {
        Circle()
            .frame(width: circleDiameter, height: circleDiameter)
            .foregroundColor(.whiteNormal)
            .elevation(isEnabled ? .custom(opacity: 0.25, radius: 1.4, y: 1.2, padding: .small) : nil)
            .overlay(
                Circle()
                    .strokeBorder(Self.borderColor, lineWidth: BorderWidth.hairline)
            )
            .overlay(indicatorSymbol)
            .offset(x: isOn ? width / 5 : -width / 5)
    }

    @ViewBuilder var indicatorSymbol: some View {
        if hasIcon {
            Icon(isOn ? .lock : .lockOpen, size: .small, color: iconTint)
        } else {
            Circle()
                .foregroundColor(tint)
                .frame(width: dotDiameter, height: dotDiameter)
        }
    }

    var tint: Color {
        (isOn ? Color.blueNormal : Color.cloudDarker)
            .opacity(isEnabled ? 1 : 0.5)
    }

    var iconTint: Color {
        (isOn ? Color.blueNormal : Color.inkLight)
            .opacity(isEnabled ? 1 : 0.5)
    }

    var width: CGFloat {
        Self.size.width * sizeCategory.ratio
    }

    var height: CGFloat {
        Self.size.height * sizeCategory.ratio
    }

    var circleDiameter: CGFloat {
        Self.circleDiameter * sizeCategory.ratio
    }

    var dotDiameter: CGFloat {
        Self.dotDiameter * sizeCategory.ratio
    }

    /// Creates Orbit Switch component.
    public init(isOn: Binding<Bool>, hasIcon: Bool = false, isEnabled: Bool = true) {
        self._isOn = isOn
        self.hasIcon = hasIcon
        self.isEnabled = isEnabled
    }
}

// MARK: - Previews
struct SwitchPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            standalone
            storybook
        }
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        StateWrapper(initialState: true) { state in
            Switch(isOn: state)
        }
        .padding(.medium)
    }

    static var storybook: some View {
        VStack(spacing: .large) {
            HStack(spacing: .large) {
                switchView(isOn: true)
                switchView(isOn: true, hasIcon: true)
                switchView(isOn: true, isEnabled: false)
                switchView(isOn: true, hasIcon: true, isEnabled: false)
            }
            HStack(spacing: .large) {
                switchView(isOn: false)
                switchView(isOn: false, hasIcon: true)
                switchView(isOn: false, isEnabled: false)
                switchView(isOn: false, hasIcon: true, isEnabled: false)
            }
        }
        .padding(.medium)
    }

    static var snapshot: some View {
        storybook
    }

    static func switchView(isOn: Bool, hasIcon: Bool = false, isEnabled: Bool = true) -> some View {
        StateWrapper(initialState: isOn) { isOnState in
            Switch(isOn: isOnState, hasIcon: hasIcon, isEnabled: isEnabled)
        }
    }
}

struct SwitchDynamicTypePreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            content
                .environment(\.sizeCategory, .extraSmall)
                .previewDisplayName("Dynamic Type - XS")
            content
                .environment(\.sizeCategory, .accessibilityExtraLarge)
                .previewDisplayName("Dynamic Type - XL")
        }
        .previewLayout(.sizeThatFits)
    }

    @ViewBuilder static var content: some View {
        SwitchPreviews.storybook
    }
}
