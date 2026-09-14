import SwiftUI
import Tagged

enum BookModuleViewData {
    case services([ServiceButtonViewData])
    case recommendedClasses([GroupClassCardViewData])
    case contentCard(ContentCardViewData)
    case challenges([JoinChallengeCardViewData])
}

struct BookScreen: View {
    let modules: [BookModuleViewData]
    @State private var selectedClass: GroupClassCardViewData?
    @State private var showsClassDetail = false

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: .spacingXL) {
                ForEach(modules.enumerated(), id: \.offset) { _, module in
                    switch module {
                    case let .services(services):
                        BookingServicesCard(services: services)
                            .padding(.horizontal, .spacingM)

                    case let .recommendedClasses(classes):
                        TitledSection(title: "Recommended Classes") {
                            ScrollView(.horizontal) {
                                HStack(spacing: .spacingXS) {
                                    ForEach(classes, id: \.id) { viewData in
                                        GroupClassCard(viewData: viewData) {
                                            openDetail(viewData)
                                        }
                                        .onTapGesture { openDetail(viewData) }
                                        .accessibilityAction(named: "View class details") {
                                            openDetail(viewData)
                                        }
                                    }
                                }
                            }
                            .contentMargins(.horizontal, .spacingM)
                        }

                    case let .contentCard(viewData):
                        ContentCard(viewData: viewData)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, .spacingM)

                    case let .challenges(challenges):
                        TitledSection(title: "Ready for a challenge?") {
                            ScrollView(.horizontal) {
                                HStack(alignment: .top, spacing: .spacingXS) {
                                    ForEach(challenges.enumerated(), id: \.offset) { _, viewData in
                                        JoinChallengeCard(viewData: viewData)
                                    }
                                }
                            }
                            .contentMargins(.horizontal, .spacingM)
                        }
                    }
                }

                Spacer(minLength: 80)
            }
            .padding(.vertical, .spacingL)
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .navigationTitle("Book")
        .toolbarTitleDisplayMode(.inlineLarge)
        .navigationDestination(isPresented: $showsClassDetail) {
            if let selectedClass {
                GroupClassDetailScreen(viewData: .previewValue(
                    groupClass: selectedClass,
                    room: "Cycling Studio"
                ))
            }
        }
    }

    private func openDetail(_ groupClass: GroupClassCardViewData) {
        selectedClass = groupClass
        showsClassDetail = true
    }
}

extension BookModuleViewData {
    static var previewModules: [Self] {
        [
            .services([
                .init(iconName: "person.3.fill", title: "Group Class"),
                .init(iconName: "figure.strengthtraining.traditional", title: "Personal Trainer"),
                .init(iconName: "figure.flexibility", title: "Physiotherapy")
            ]),
            .recommendedClasses([
                .previewValue(id: "cycling-1"),
                .previewValue(id: "cycling-2"),
                .previewValue(id: "cycling-3")
            ]),
            .contentCard(.previewValue(
                text: """
                It is a long established fact that a reader will be distracted by the readable content of a page when \
                looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution \
                of letters, as opposed to using 'Content here, content here'
                """,
                image: nil
            )),
            .challenges([.previewValue(), .previewValue(), .previewValue()])
        ]
    }
}

#Preview {
    NavigationStack {
        BookScreen(modules: BookModuleViewData.previewModules)
    }
}
