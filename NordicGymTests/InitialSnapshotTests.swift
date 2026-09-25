import SwiftUI
import SnapshotTesting
import Testing
@testable import NordicGym

@MainActor
@Suite
struct `Initial Snapshots` {
    @Test func `sample content`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.dataClient, .test())

        assertSnapshot(of: view, as: .image)
    }
}

extension `Initial Snapshots` {
    @Test func `sample content in Norwegian`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.dataClient, .test())
        .environment(\.locale, .init(identifier: "nb"))

        assertSnapshot(of: view, as: .image)
    }

    @Test func `sample content - accessibility`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
            .environment(\.dataClient, .test())

        assertSnapshot(
            of: view,
            as: .image(
                traits: .init(preferredContentSizeCategory: .accessibilityExtraExtraLarge)
            )
        )
    }

    @Test func `sample content - all scrollable size`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.dataClient, .test())

        assertSnapshot(of: view, as: .image(layout: .fixed(width: 402, height: 1800)))
    }

    @Test func `sample content - all scrollable size - dynamic type`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.dataClient, .test())

        assertSnapshot(
            of: view,
            as: .image(
                layout: .fixed(width: 402, height: 1800),
                traits: .init(preferredContentSizeCategory: .accessibilityExtraExtraLarge)
            )
        )
    }

    @Test func `sample content - dark mode`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.dataClient, .test())
        .environment(\.colorScheme, .dark)

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13Pro(.landscape)), traits: .iPhone13ProMax(.landscape))
        )
    }

    @Test func `sample content - iPad Landscape`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.dataClient, .test())
        .environment(\.colorScheme, .dark)

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPadPro11(.landscape)), traits: .iPadPro11)
        )
    }

    @Test func `sample content - iPad Portrait`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.dataClient, .test())
        .environment(\.colorScheme, .dark)

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPadPro11(.portrait)), traits: .iPadPro11)
        )
    }

    @Test func `sample content - iPad Portrait - Split One Third`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.dataClient, .test())
        .environment(\.colorScheme, .light)

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPadPro11(.portrait(splitView: .oneThird))), traits: .iPadPro11)
        )
    }

    @Test func `sample content - iPad Portrait - Split Two Thirds`() async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.dataClient, .test())
        .environment(\.colorScheme, .light)

        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: .iPadPro11(.portrait(splitView: .twoThirds))), traits: .iPadPro11)
        )
    }
}
