@testable import NordicGym
import Testing
import SwiftUI
import SnapshotTesting

@MainActor
@Suite struct `Upcoming Classes Card Snapshot Tests` {
    @Test(arguments: SnapshotVariant.defaultVariants())
    func `empty state`(variant: SnapshotVariant) {
        let view = ContainerView {
            UpcomingClassesCard(
                sections: []
            )
        }

        expectSnapshot(of: view, on: variant)
    }

    @Test(arguments: SnapshotVariant.defaultVariants())
    func `some data state`(variant: SnapshotVariant) {
        let view = ContainerView {
            UpcomingClassesCard(
                sections: [
                    .previewValue(title: "Tomorrow", classes: [.previewValue(), .previewValue()]),
                    .previewValue(title: "Sunday", classes: [.previewValue()]),
                ]
            )
        }

        expectSnapshot(of: view, on: variant)
    }

    @Test(arguments: SnapshotVariant.defaultVariants())
    func `with a very long name`(variant: SnapshotVariant) {
        let view = ContainerView {
            UpcomingClassesCard(
                sections: [
                    .previewValue(
                        title: "Tomorrow",
                        classes: [
                            .previewValue(),
                            .previewValue(className: """
                                The toughest class known to mankind, it will test your limits to the extreme and \
                                definitively not for the faint of heart.
                                """
                            )
                        ]
                    ),
                    .previewValue(title: "Sunday", classes: [.previewValue()]),
                ]
            )
        }

        expectSnapshot(of: view, on: variant)
    }

    private struct ContainerView<Content: View>: View {
        @ViewBuilder let content: Content

        var body: some View {
            NavigationStack {
               content
                    .padding(.horizontal)
                    .navigationTitle("Upcoming Classes")
                    .navigationBarTitleDisplayMode(.inline)
           }
        }
    }
}
