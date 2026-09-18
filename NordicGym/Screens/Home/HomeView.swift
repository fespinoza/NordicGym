import SwiftUI

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
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Image(.nordicGymLogo)
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }
}
