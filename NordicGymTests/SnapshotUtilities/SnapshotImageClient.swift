import SwiftUI
@testable import NordicGym

/// Helper to get concrete sample images for the URLs defined in the sample data as JSON
struct SnapshotImageClient: ImageClient {
    func cachedImage(for url: URL) -> Image? {
        TestImages.image(for: url)
    }

    func loadImage(with url: URL) async throws -> Image {
        guard let image = cachedImage(for: url) else {
            throw MissingImage(url: url)
        }
        return image
    }

    struct MissingImage: Error {
        let url: URL
    }
}
