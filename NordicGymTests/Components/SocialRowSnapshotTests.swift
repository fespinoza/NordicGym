@testable import NordicGym
import Testing
import SwiftUI
import SnapshotTesting

@MainActor @Suite struct `Social Row Tests` {
    @Test(arguments: SnapshotVariant.defaultVariants(checkAccessibility: true))
    func `social row`(variant: SnapshotVariant) async throws {
        let view = VStack {
            row(.previewValue(profilePicture: .loading, isLiked: true))
            row(.previewValue(profilePicture: .image(Image(.homeErikPortrait)), isLiked: false))
            row(.previewValue(profilePicture: .none, isLiked: false))
            row(.previewValue(
                message: """
                **Diego Fernando Morales Castañeda Fernandez** \
                did the toughest class known to mankind
                """
            ))
        }
        .padding()

        expectSnapshot(of: view, on: variant)
    }

    private func row(_ viewData: SocialActivityRowViewData) -> some View {
        SocialActivityRow(viewData: viewData)
    }
}
