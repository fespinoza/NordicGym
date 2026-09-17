@testable import NordicGym
import Testing
import SwiftUI
import SnapshotTesting

@MainActor @Suite struct `Home Screen Snapshots` {
    @Test func `sample content`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.networkingClient, .forTest())

        assertSnapshot(of: view, as: .image)
    }

    @Test func `sample content - all scrollable size`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.networkingClient, .forTest())

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 402, height: 1800)))
    }

    @Test func `sample content - dark mode`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.networkingClient, .forTest())
        .environment(\.colorScheme, .dark)

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13Pro(.landscape)), traits: .iPhone13ProMax(.landscape))
        )
    }

}
