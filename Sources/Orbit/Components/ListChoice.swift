import SwiftUI

public enum ListChoiceDisclosure: Equatable {
    
    public enum ButtonType {
        case add
        case remove
    }
    
    case none
    /// An iOS-style disclosure indicator.
    case disclosure(Color = .inkLight)
    /// A non-interactive button.
    case button(type: ButtonType)
    /// A non-interactive checkbox.
    case checkbox(isChecked: Bool = true, state: Checkbox.State = .normal)
    /// A non-interactive radio.
    case radio(isChecked: Bool = true, state: Radio.State = .normal)
}

/// Shows one of a selectable list of items with similar structures.
///
/// - Note: [Orbit definition](https://orbit.kiwi/components/listchoice/)
/// - Important: Component expands horizontally up to ``Layout/readableMaxWidth``.
public struct ListChoice<HeaderContent: View, Content: View>: View {

    public let verticalPadding: CGFloat = .small + 1/3   // Makes height exactly 45 at normal text size

    let title: String
    let description: String
    let iconContent: Icon.Content
    let disclosure: ListChoiceDisclosure
    let showSeparator: Bool
    let action: () -> Void
    let content: () -> Content
    let headerContent: () -> HeaderContent

    public var body: some View {
        SwiftUI.Button(
            action: {
                HapticsProvider.sendHapticFeedback(.light(0.5))
                action()
            },
            label: {
                buttonContent
            }
        )
        .buttonStyle(ListChoiceButtonStyle())
        .accessibility(label: SwiftUI.Text(title))
        .accessibility(hint: SwiftUI.Text(description))
        .accessibility(removeTraits: accessibilityTraitsToRemove)
        .accessibility(addTraits: accessibilityTraitsToAdd)
    }

    @ViewBuilder var buttonContent: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                header
                content()
            }

            disclosureView
                .padding(.horizontal, .medium)
        }
        .frame(maxWidth: Layout.readableMaxWidth, alignment: .leading)
        .overlay(separator, alignment: .bottom)
    }
    
    @ViewBuilder var header: some View {
        HStack(spacing: 0) {
            headerTexts

            if isHeaderEmpty == false {
                Spacer(minLength: .xSmall)
            }

            TextStrut(.large)
                .padding(.vertical, verticalPadding)

            headerContent()
                .padding(.trailing, disclosure == .none ? .medium : 0)
        }
    }
    
    @ViewBuilder var headerTexts: some View {
        if isHeaderEmpty == false {
            HStack(alignment: .firstTextBaseline, spacing: .xSmall) {
                Icon(iconContent)
                    .foregroundColor(.inkNormal)
                
                if isHeaderTextEmpty == false {
                    VStack(alignment: .labelTextLeading, spacing: .xxxSmall) {
                        Text(title, weight: .medium)
                        Text(description, size: .small, color: .inkLight)
                    }
                }
            }
            .padding(.leading, .medium)
            .padding(.vertical, verticalPadding)
        }
    }

    @ViewBuilder var disclosureView: some View {
        switch disclosure {
            case .none:
                EmptyView()
            case .disclosure(let color):
                Icon(.symbol(.chevronRight, color: color))
                    .padding(.leading, -.xSmall)
            case .button(let type):
                disclosureButton(type: type)
                    .padding(.vertical, .small)
                    .disabled(true)
            case .checkbox(let isChecked, let state):
                Checkbox(state: state, isChecked: isChecked)
                    .disabled(true)
            case .radio(let isChecked, let state):
                Radio(state: state, isChecked: isChecked)
                    .disabled(true)
        }
    }
    
    @ViewBuilder func disclosureButton(type: ListChoiceDisclosure.ButtonType) -> some View {
        switch type {
            case .add:      Button(.plus, style: .primarySubtle, size: .small).fixedSize()
            case .remove:   Button(.close, style: .criticalSubtle, size: .small).fixedSize()
        }
    }

    @ViewBuilder var separator: some View {
        if showSeparator {
            Separator(thickness: .hairline)
                .padding(.leading, separatorPadding)
        }
    }

    var separatorPadding: CGFloat {
        if isHeaderEmpty {
            return 0
        }
        
        if iconContent.isEmpty {
            return .medium
        }
        
        return .xxLarge
    }
    
    var isHeaderEmpty: Bool {
        iconContent.isEmpty && isHeaderTextEmpty
    }

    var isHeaderTextEmpty: Bool {
        title.isEmpty && description.isEmpty
    }
    
    var accessibilityTraitsToAdd: AccessibilityTraits {
        switch disclosure {
            case .none, .disclosure, .button, .checkbox(false, _), .radio(false, _):    return []
            case .checkbox(true, _), .radio(true, _):                                   return .isSelected
        }
    }
    
    var accessibilityTraitsToRemove: AccessibilityTraits {
        switch disclosure {
            case .none, .disclosure, .button, .checkbox(true, _), .radio(true, _):      return []
            case .checkbox(false, _), .radio(false, _):                                 return .isSelected
        }
    }
}

// MARK: - Inits
public extension ListChoice {
    
    /// Creates Orbit ListChoice component with optional content and header content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder headerContent: @escaping () -> HeaderContent
    ) {
        self.title = title
        self.description = description
        self.iconContent = icon
        self.disclosure = disclosure
        self.showSeparator = showSeparator
        self.action = action
        self.content = content
        self.headerContent = headerContent
    }

    /// Creates Orbit ListChoice component with optional header content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder headerContent: @escaping () -> HeaderContent
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action,
            content: { EmptyView() },
            headerContent: headerContent
        )
    }

    /// Creates Orbit ListChoice component with optional content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) where HeaderContent == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action,
            content: content,
            headerContent: { EmptyView() }
        )
    }

    /// Creates Orbit ListChoice component.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {}
    ) where HeaderContent == EmptyView, Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action,
            content: { EmptyView() },
            headerContent: { EmptyView() }
        )
    }
}

public extension ListChoice where HeaderContent == Text {

    /// Creates Orbit ListChoice component with text based header value and optional custom content.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        value: String,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            title,
            description: description,
            icon: icon,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action,
            content: content
        ) {
            Text(value, weight: .medium)
        }
    }

    /// Creates Orbit ListChoice component with text based header value.
    init(
        _ title: String = "",
        description: String = "",
        icon: Icon.Content = .none,
        value: String,
        disclosure: ListChoiceDisclosure = .disclosure(),
        showSeparator: Bool = true,
        action: @escaping () -> Void = {}
    ) where Content == EmptyView {
        self.init(
            title,
            description: description,
            icon: icon,
            value: value,
            disclosure: disclosure,
            showSeparator: showSeparator,
            action: action,
            content: { EmptyView() }
        )
    }
}

extension ListChoice {
    
    // Button style wrapper for ListChoice.
    // Solves the touch-down, touch-up animations that would otherwise need gesture avoidance logic.
    struct ListChoiceButtonStyle: SwiftUI.ButtonStyle {

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(
                    backgroundColor(isPressed: configuration.isPressed)
                        .contentShape(Rectangle())
                )
        }

        func backgroundColor(isPressed: Bool) -> Color {
            isPressed ? .inkLight.opacity(0.08) : .clear
        }
    }
}

// MARK: - Previews
struct ListChoicePreviews: PreviewProvider {

    static let title = "ListChoice tile"
    static let description = "Further description"
    static let value = "Value"
    static let badge = Badge("3", style: .status(.info, inverted: false))
    static let addButton = ListChoiceDisclosure.button(type: .add)
    static let removeButton = ListChoiceDisclosure.button(type: .remove)
    static let uncheckedCheckbox = ListChoiceDisclosure.checkbox(isChecked: false)
    static let checkedCheckbox = ListChoiceDisclosure.checkbox(isChecked: true)

    static var previews: some View {
        PreviewWrapper {
            standalone
            sizing
            storybook
            storybookButton
            storybookCheckbox
            storybookRadio
            plain
            white
            backgroundColor
        }
        .background(Color.cloudLight)
        .previewLayout(.sizeThatFits)
    }

    static var standalone: some View {
        ListChoice(title, description: description, icon: .grid) {
            customContentPlaceholder
        } headerContent: {
            headerContent
        }
    }

    static var sizing: some View {
        VStack(spacing: .medium) {
            Group {
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ListChoice("Height \(state.wrappedValue)", description: description, icon: .grid, value: value)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ListChoice("Height \(state.wrappedValue)", icon: .grid, value: value)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ListChoice(description: "Height \(state.wrappedValue)", icon: .grid)
                    }
                }
                StateWrapper(initialState: CGFloat(0)) { state in
                    ContentHeightReader(height: state) {
                        ListChoice("Height \(state.wrappedValue)")
                    }
                }
            }
            .border(Color.cloudLight)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.medium)
        .background(Color.whiteNormal)
        .previewDisplayName("Sizing")
    }
    
    static var storybook: some View {
        Card(contentLayout: .fill) {
            ListChoice(title)
            ListChoice(title, value: "10")
            ListChoice(title, description: description)
            ListChoice(title, description: "Multiline\ndescription", value: "USD")
            ListChoice(title, icon: .airplane)
            ListChoice(title, icon: .airplane, value: value)
            ListChoice(title, description: description, icon: .airplane)
            ListChoice(title, description: description, icon: .airplane, value: value)
            ListChoice(title, description: description, headerContent: {
                badge
            })
            ListChoice(title, description: description, icon: .grid, headerContent: {
                badge
            })
        }
    }
    
    static var storybookButton: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: addButton)
            ListChoice(title, disclosure: removeButton)
            ListChoice(title, description: description, disclosure: addButton)
            ListChoice(title, description: description, disclosure: removeButton)
            ListChoice(title, icon: .airplane, disclosure: addButton)
            ListChoice(title, icon: .airplane, disclosure: removeButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: addButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton)
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: addButton)
            ListChoice(title, description: description, icon: .airplane, disclosure: removeButton) {
                customContentPlaceholder
            } headerContent: {
                headerContent
            }
        }
        .previewDisplayName("Button")
    }

    static var storybookCheckbox: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: uncheckedCheckbox)
            ListChoice(title, disclosure: checkedCheckbox)
            ListChoice(title, description: description, disclosure: .checkbox(state: .error))
            ListChoice(title, description: description, disclosure: .checkbox(state: .disabled))
            ListChoice(title, icon: .airplane, disclosure: .checkbox(isChecked: false, state: .error))
            ListChoice(title, icon: .airplane, disclosure: .checkbox(isChecked: false, state: .disabled))
            ListChoice(title, description: description, icon: .airplane, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox)
            ListChoice(title, description: description, icon: .airplane, value: value, disclosure: uncheckedCheckbox)
            ListChoice(title, description: description, icon: .airplane, disclosure: checkedCheckbox) {
                customContentPlaceholder
            } headerContent: {
                headerContent
            }
        }
        .previewDisplayName("Checkbox")
    }

    static var storybookRadio: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, description: description, disclosure: .radio(isChecked: false))
            ListChoice(title, description: description, disclosure: .radio(isChecked: true))
            ListChoice(title, description: description, disclosure: .radio(state: .error))
            ListChoice(title, description: description, disclosure: .radio(state: .disabled))
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false, state: .error))
            ListChoice(title, icon: .airplane, disclosure: .radio(isChecked: false, state: .disabled))
            ListChoice(title, description: description, icon: .airplane, disclosure: .radio(isChecked: false)) {
                customContentPlaceholder
            } headerContent: {
                headerContent
            }
        }
        .previewDisplayName("Checkbox")
    }

    static var storybookMix: some View {
        VStack(spacing: .xLarge) {
            plain
            white
            backgroundColor
        }
    }

    static var plain: some View {
        Card(contentLayout: .fill) {
            ListChoice(title, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none)
            ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false)
            ListChoice(title, icon: .airplane, disclosure: .none)
            ListChoice(title, icon: .symbol(.airplane, color: .blueNormal), disclosure: .none)
            ListChoice(title, description: description, icon: .countryFlag("cs"), disclosure: .none)
            ListChoice(title, description: description, icon: .grid, value: value, disclosure: .none)
            ListChoice(title, description: description, disclosure: .none, headerContent: {
                badge
            })
            ListChoice(disclosure: .none) {
                customContentPlaceholder
            } headerContent: {
                headerContent
            }
        }
        .previewDisplayName("No disclosure")
    }
    
    static var white: some View {
        VStack(spacing: .small) {
            Group {
                ListChoice(title, disclosure: .none)
                ListChoice(disclosure: .none)
                ListChoice(title, description: description, disclosure: .none)
                ListChoice(title, description: "No Separator", disclosure: .none, showSeparator: false)
                ListChoice(title, icon: .airplane, disclosure: .none)
                ListChoice(title, icon: .symbol(.airplane, color: .inkLighter), disclosure: .none)
                ListChoice(title, description: description, icon: .airplane, disclosure: .none)
                ListChoice(title, description: description, disclosure: .none) {
                    customContentPlaceholder
                } headerContent: {
                    headerContent
                }
            }
            .background(Color.whiteNormal)
        }
        .padding()
        .background(Color.cloudLight)
        .previewDisplayName("White background")
    }
    
    static var backgroundColor: some View {
        VStack(spacing: .small) {
            Group {
                ListChoice(title, value: value, disclosure: .none)
                ListChoice(disclosure: .none)
                ListChoice(title, icon: .grid, value: value)
                ListChoice(title, icon: .grid, content: {
                    customContentPlaceholder
                })
            }
            .background(Color.orangeLight)
        }
        .padding()
        .background(Color.cloudLight)
        .previewDisplayName("Custom background")
    }

    static var headerContent: some View {
        Text("Custom\nheader content")
            .padding(.vertical, .medium)
            .frame(maxWidth: .infinity)
            .background(Color.blueLightActive)
    }
}

struct ListChoiceDynamicTypePreviews: PreviewProvider {

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
        ListChoicePreviews.standalone
        ListChoice(ListChoicePreviews.title, disclosure: ListChoicePreviews.addButton)
        ListChoice(ListChoicePreviews.title, disclosure: ListChoicePreviews.uncheckedCheckbox)
    }
}
