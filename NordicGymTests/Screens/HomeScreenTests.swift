@testable import NordicGym
import Testing
import SwiftUI
import SnapshotTesting

@MainActor @Suite struct `Home Screen Snapshots` {
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
        ] as [SnapshotVariant]
    )
    func `sample content`(variant: SnapshotVariant) async throws {
        let view = NavigationStack {
            HomeScreen()
        }
        .environment(\.dataClient, .test())

        expectSnapshot(of: view, on: variant)
    }

    @Test(arguments: SnapshotVariant.defaultVariants(checkAccessibility: true))
    func `home content`(variant: SnapshotVariant) async throws {
        let view = NavigationStack { HomeScreen() }.environment(\.dataClient, .test())
        expectSnapshot(of: view, on: variant)
    }

    @Test(arguments: SnapshotVariant.defaultVariants(checkAccessibility: true))
    func `home content - controlling the time zones`(variant: SnapshotVariant) async throws {
        let view = NavigationStack { HomeScreen() }
            .environment(
                \.dataClient.fetchHomeContent,
                 {
                     [
                        .upcomingWorkouts(
                        [
                            .previewValue(
                                title: "Tomorrow",
                                classes: [.previewValue(time: "17:30")]
                            ),
                            .previewValue(
                                title: "Friday",
                                classes: [.previewValue(className: "Rowing", instructorName: "Erling", time: "18:30")]
                            ),
                            .previewValue(
                                title: "Saturday",
                                classes: [
                                    .previewValue(className: "Yoga Flow", instructorName: "Ingrid", time: "10:00")
                                ]
                            ),
                        ]
                     )]
                 }
            )

        expectSnapshot(of: view, on: variant)
    }

    @Test(arguments: SnapshotVariant.defaultVariants(checkAccessibility: true))
    func `home content with social features off and no upcoming classes`(variant: SnapshotVariant) async throws {
        let view = NavigationStack {
            HomeScreen()
        }.environment(
            \.dataClient.fetchHomeContent,
             {
                 [
                    .upcomingWorkouts([]),
                    .contentCard(.previewValue())
                 ]
             }
        )
        expectSnapshot(of: view, on: variant)
    }
}
