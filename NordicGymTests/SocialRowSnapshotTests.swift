@testable import NordicGym
import Testing
import SwiftUI
import SnapshotTesting

@MainActor @Suite struct `Social Row Tests` {
    @Test(arguments: SnapshotVariant.defaultVariants(checkAccessibility: true))
    func `social row`(variant: SnapshotVariant) async throws {
        let view = VStack {
            SocialActivityRow(viewData: .previewValue(profilePicture: .loading, isLiked: true))
            SocialActivityRow(viewData: .previewValue(profilePicture: .image(Image(.homeErikPortrait)), isLiked: false))
            SocialActivityRow(viewData: .previewValue(profilePicture: .none, isLiked: false))
            SocialActivityRow(
                viewData: .previewValue(
                    message: "**Diego Fernando Morales Castañada Fernandez** did the most tough class known to mankind"
                )
            )
        }
        .padding()

        expectSnapshot(of: view, on: variant)
    }
}
