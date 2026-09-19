import SwiftUI

struct HomeView: View {
    let modules: [HomeModuleViewData]

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: .spacingXL) {
                ForEach(modules) { module in
                    HomeModuleSection(module: module)
                }

                Spacer(minLength: 80)
            }
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
            .padding(.vertical, .spacingL)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Image(.nordicGymLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 136, height: 28)
                    .accessibilityLabel("NordicGym")
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }
}

private struct HomeModuleSection: View {
    let module: HomeModuleViewData

    var body: some View {
        VStack(alignment: .leading) {
            switch module {
            case let .upcomingWorkouts(viewData):
                TitledSection(title: "Upcoming Classes") {
                    UpcomingClassesCard(sections: viewData)
                        .padding(.horizontal, .spacingM)
                }

            case let .friendActivity(viewData):
                TitledSection(title: "Latest Friend Activity") {
                    FriendActivityCard(rows: viewData)
                        .padding(.horizontal, .spacingM)
                }

            case let .joinYourFriends(viewData):
                TitledSection(title: "Join Your Friends") {
                    JoinYourFriendsCard(friendClasses: viewData)
                        .contentMargins(.horizontal, .spacingM)
                }

            case let .contentCard(viewData):
                HomeContentCard(viewData: viewData)
                    .padding(.horizontal, .spacingM)
            }
        }
    }
}
