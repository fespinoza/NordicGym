@testable import NordicGym
import Testing
import SwiftUI
import SnapshotTesting

@MainActor @Suite struct `New Home Screen Snapshots` {
    @Test(
        arguments: [
            .init(device: .iPhone, colorScheme: .light),
            .init(device: .iPhone, colorScheme: .light, dynamicTypeSize: .accessibility4),
            .init(device: .fixedSize(height: 1600), colorScheme: .light),
            .init(
                device: .fixedSize(height: 1600),
                colorScheme: .light,
                dynamicTypeSize: .accessibility4
            ),
            .init(device: .iPhone(.landscape), colorScheme: .dark),
            .init(device: .iPad(.portrait), colorScheme: .dark),
            .init(device: .iPad(.landscape), colorScheme: .light),
            .init(device: .iPad(.portrait(splitView: .oneThird)), colorScheme: .light),
            .init(device: .iPad(.portrait(splitView: .twoThirds)), colorScheme: .dark),
            .init(device: .iPad(.landscape(splitView: .oneThird)), colorScheme: .dark),
            .init(device: .iPad(.landscape(splitView: .twoThirds)), colorScheme: .dark),
        ] as [SnapshotVariant]
    )
    func `sample content`(variant: SnapshotVariant) async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.networkingClient, .test())

        expectSnapshot(of: view, on: variant)
    }

    @Test(arguments: SnapshotVariant.defaultVariants(checkAccessibility: true))
    func `home content`(variant: SnapshotVariant) async throws {
        let view = NavigationStack { HomeScreen() }.environment(\.networkingClient, .test())
        expectSnapshot(of: view, on: variant)
    }

    @Test(arguments: SnapshotVariant.defaultVariants(checkAccessibility: true))
    func `home content with social features off and no upcoming classes`(variant: SnapshotVariant) async throws {
        let view = NavigationStack {
            HomeScreen()
        }.environment(
            \.networkingClient,
             .init(
                fetchHomeContent: {
                    try NetworkingClient.fixtureFile(fileName: "home-sample-no-social")
                }
             )
        )
        expectSnapshot(of: view, on: variant)
    }
}
