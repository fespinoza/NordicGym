import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .padding(.spacingM)
            .font(.subheadline)
            .background {
                RoundedRectangle(cornerRadius: .cornerRadiusM)
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))

            }
    }

    func homeCardStyle(contentPadding: CGFloat = .spacingM) -> some View {
        self
            .padding(contentPadding)
            .background {
                RoundedRectangle(cornerRadius: .cornerRadiusL)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            }
            .overlay {
                RoundedRectangle(cornerRadius: .cornerRadiusL)
                    .stroke(Color.primary.opacity(0.08))
            }
    }
}
