import SwiftUI

struct TitledSection<Content: View>: View {
    let title: LocalizedStringResource
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingM) {
            Text(title)
                .font(.title2.bold())
                .padding(.horizontal, .spacingM)
                .accessibilityAddTraits(.isHeader)

            content
        }
    }
}
