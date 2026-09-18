@testable import NordicGym
import Testing
import SwiftUI
import Tagged
import SnapshotTesting

@MainActor @Suite struct `Group Class Details` {
    static let sampleClassIDs: [GroupClassID] = [
        .init(rawValue: "cycling-20260911-1630"),
        .init(rawValue: "dance-energy-20260913-1600"),
        .init(rawValue: "love2dance-20260911-1730"),
        .init(rawValue: "rowing-20260912-1830"),
        .init(rawValue: "strength-express-20260912-1200"),
        .init(rawValue: "yoga-flow-20260913-1000"),
        .init(rawValue: "yoga-morning-20260912-0900"),
    ]

    @Test(
        arguments: SnapshotVariant.defaultVariants(checkAccessibility: true)
    )
    func `sample class content`(variant: SnapshotVariant) async throws {
        let view = NavigationStack {
            GroupClassScreen(id: Self.sampleClassIDs[0])
        }
        .environment(\.networkingClient, .test())

        expectSnapshot(of: view, on: variant)
    }

    @Test(arguments: SnapshotVariant.fixedHeightVariants(height: 1600), sampleClassIDs)
    func `full class content`(variant: SnapshotVariant, classId: GroupClassID) async throws {
        let view = NavigationStack {
            GroupClassScreen(id: classId)
        }
        .environment(\.networkingClient, .test())

        expectSnapshot(of: view, on: variant, appendName: classId.rawValue)
    }
}
