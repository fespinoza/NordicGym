@testable import NordicGym
import Testing
import SwiftUI
import SnapshotTesting

@MainActor @Suite struct `Book Screen Snapshots` {
    @Test(
        arguments: SnapshotVariant.defaultVariants(checkAccessibility: true)
    )
    func `booking landing content`(variant: SnapshotVariant) async throws {
        let view = NavigationStack { BookScreen() }.environment(\.dataClient, .test())
        expectSnapshot(of: view, on: variant)
    }

    @Test(arguments: SnapshotVariant.fixedHeightVariants(height: 1200))
    func `booking landing content - full height`(variant: SnapshotVariant) async throws {
        let view = NavigationStack { BookScreen() }.environment(\.dataClient, .test())
        expectSnapshot(of: view, on: variant)
    }
}
