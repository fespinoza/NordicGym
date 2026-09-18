import SwiftUI
import Tagged

enum BookModuleViewData: Equatable {
    case services([ServiceButtonViewData])
    case recommendedClasses([GroupClassCardViewData])
    case contentCard(ContentCardViewData)
    case challenges([JoinChallengeCardViewData])

    init(dto: BookModule) {
        switch dto {
        case let .recommendedClasses(dto):
            let groupClasses = dto.map { GroupClassCardViewData(dto: $0) }
            self = .recommendedClasses(groupClasses)

        case let .featuredContent(featuredContent):
            self = .contentCard(.init(dto: featuredContent))

        case .challenges(let array):
            let challenges = array.map { JoinChallengeCardViewData(dto: $0) }
            self = .challenges(challenges)
        }
    }
}

struct BookScreen: View {
    @State var content: BasicLoadingState<[BookModuleViewData]> = .idle

    @Environment(\.networkingClient.fetchBookContent) var fetchBookContent

    var body: some View {
        BasicStateView(state: $content) { viewData in
            BookView(modules: viewData)
        } fetchData: {
            let content = try await fetchBookContent()

            var viewData: [BookModuleViewData] = [
                .services([
                    .init(iconName: "person.3.fill", title: "Group Class"),
                    .init(iconName: "figure.strengthtraining.traditional", title: "Personal Trainer"),
                    .init(iconName: "figure.flexibility", title: "Physiotherapy")
                ])
            ]
            content.forEach { dtoModule in
                viewData.append(.init(dto: dtoModule))
            }
            return viewData
        }
    }
}

struct BookView: View {
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
        .navigationTitle("Book")
        .toolbarTitleDisplayMode(.inlineLarge)
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
                imageURL: nil
            )),
            .challenges([.previewValue(), .previewValue(), .previewValue()])
        ]
    }
}

#Preview {
    NavigationStack {
        BookScreen()
    }
}
