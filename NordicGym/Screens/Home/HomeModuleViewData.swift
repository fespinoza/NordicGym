import Foundation

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
