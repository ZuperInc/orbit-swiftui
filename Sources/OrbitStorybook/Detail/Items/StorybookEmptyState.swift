import SwiftUI
import Orbit

struct StorybookEmptyState {

    static let title = "Sorry, we couldn't find that connection."
    static let description = "Try changing up your search a bit. We'll try harder next time."
    static let button = "Adjust search"

    static var basic: some View {
        VStack(spacing: .xxLarge) {
            standalone
            Separator()
            subtle
            Separator()
            noAction
        }
    }

    static var standalone: some View {
        EmptyState(title, description: description, action: .button(button),imgName: Illustration.Image.accommodation.assetName)
            .padding(.medium)
    }
    
    static var subtle: some View {
        EmptyState(title, description: description, action: .button(button, style: .primarySubtle),imgName: Illustration.Image.accommodation.assetName)
            .padding(.medium)
    }
    
    static var noAction: some View {
        EmptyState(title, description: description)
            .padding(.medium)
    }
}

struct StorybookEmptyStatePreviews: PreviewProvider {

    static var previews: some View {
        OrbitPreviewWrapper {
            StorybookEmptyState.basic
        }
    }
}
