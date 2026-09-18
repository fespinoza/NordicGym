import SwiftUI
import Testing
@testable import NordicGym

@MainActor
struct CustomAsyncImageTests {
    @Test
    func cachedImageAppearsOnFirstRender() throws {
        let url = try #require(URL(string: "https://randomuser.me/api/portraits/men/32.jpg"))
        let image = try #require(TestImages.image(for: url))
        let actual = ImageRenderer(content:
            CustomAsyncImage(state: .remote(url: url)) { $0.resizable() }
                .frame(width: 64, height: 64)
                .environment(\.imageClient, SnapshotImageClient())
        )
        let expected = ImageRenderer(content:
            image.resizable().frame(width: 64, height: 64)
        )

        let actualData = try #require(actual.uiImage?.pngData())
        let expectedData = try #require(expected.uiImage?.pngData())
        #expect(actualData == expectedData)
    }

    @Test
    func unknownSnapshotURLFailsWithoutNetworking() async throws {
        let url = try #require(URL(string: "https://example.com/missing.jpg"))
        let client = SnapshotImageClient()
        #expect(client.cachedImage(for: url) == nil)
        await #expect(throws: SnapshotImageClient.MissingImage.self) {
            try await client.loadImage(with: url)
        }
    }
}
