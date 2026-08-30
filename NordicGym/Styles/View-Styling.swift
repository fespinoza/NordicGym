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
}
