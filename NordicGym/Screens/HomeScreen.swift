//
//  HomeScreen.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 08/09/2026.
//

import SwiftUI

enum HomeModuleViewData: Equatable {
    case upcomingWorkouts([UpcomingClassesSectionViewData])
    case joinYourFriends([FriendAttendingViewData])
    case friendActivity([SocialActivityRowViewData])
    case contentCard(ContentCardViewData)
}

extension HomeModuleViewData {
    init(dto: HomeModule) {
        switch dto {
        case let .upcomingClasses(classes):
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.doesRelativeDateFormatting = true
            let classesByDay = Dictionary(grouping: classes) {
                calendar.startOfDay(for: $0.dateTime)
            }
            let sections = classesByDay.sorted { $0.key < $1.key }.map { day, classes in
                UpcomingClassesSectionViewData(
                    title: dateFormatter.string(from: day),
                    classes: classes.sorted { $0.dateTime < $1.dateTime }.map {
                        GroupClassRowViewData(dto: $0)
                    }
                )
            }
            self = .upcomingWorkouts(sections)

        case let .joinYourFriends(classes):
            let friends = classes.map { FriendAttendingViewData(dto: $0) }
            self = .joinYourFriends(friends)

        case let .friendActivity(activities):
            let rows = activities.map { SocialActivityRowViewData(dto: $0) }
            self = .friendActivity(rows)

        case let .featuredContent(featuredContent):
            self = .contentCard(.init(dto: featuredContent))
        }
    }
}

struct TitledSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.horizontal, .spacingM)

            content
        }
    }
}

struct HomeScreen: View {
    @State var content: BasicLoadingState<[HomeModuleViewData]> = .idle
    @Environment(\.networkingClient.fetchHomeContent) var fetchHomeContent

    var body: some View {
        BasicStateView(state: $content) { viewData in
            HomeView(modules: viewData)
        } fetchData: {
            let dto = try await fetchHomeContent()
            return dto.map { HomeModuleViewData(dto: $0) }
        }
    }
}

struct HomeView: View {
    let modules: [HomeModuleViewData]

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: .spacingXL) {
                ForEach(modules.enumerated(), id: \.offset) { (element, offset) in
                    switch offset {
                    case let .upcomingWorkouts(viewData):
                        UpcomingClassesCard(sections: viewData)
                            .padding(.horizontal, .spacingM)

                    case let .friendActivity(viewData):
                        TitledSection(title: "Latest Friend Activity") {
                            FriendActivityCard(rows: viewData)
                                .padding(.horizontal, .spacingM)
                        }

                    case let .joinYourFriends(viewData):
                        TitledSection(title: "Join Your Friends") {
                            JoinYourFriendsCard(friendClasses: viewData)
                                .contentMargins(.leading, .spacingM)
                        }

                    case let .contentCard(viewData):
                        ContentCard(viewData: viewData)
                            .padding(.horizontal, .spacingM)
                    }
                }

                Spacer(minLength: 80)
            }
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Image(.nordicGymLogo)
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreen()
    }
}
