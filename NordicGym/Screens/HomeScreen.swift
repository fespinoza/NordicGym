//
//  HomeScreen.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 08/09/2026.
//

import SwiftUI

enum HomeModuleViewData {
    case upcomingWorkouts([UpcomingClassesSectionViewData])
    case joinYourFriends([FriendAttendingViewData])
    case friendActivity([SocialActivityRowViewData])
    case contentCard(ContentCardViewData)
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
        HomeScreen(modules: [
            .upcomingWorkouts([.previewValue()]),
            .friendActivity([.previewValue(), .previewValue(), .previewValue()]),
            .joinYourFriends([.previewValue(), .previewValue(), .previewValue(), .previewValue()]),
            .contentCard(.previewValue())
        ])
    }
}
