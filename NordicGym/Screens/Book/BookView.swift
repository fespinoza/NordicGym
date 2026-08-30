import SwiftUI

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
