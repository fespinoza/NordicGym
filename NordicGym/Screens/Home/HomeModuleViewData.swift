import SwiftUI
import Tagged

enum HomeModuleViewData: Equatable, Identifiable {
    case upcomingWorkouts([UpcomingClassesSectionViewData])
    case joinYourFriends([FriendAttendingViewData])
    case friendActivity([SocialActivityRowViewData])
    case contentCard(ContentCardViewData)

    enum ID: Hashable {
        case upcomingWorkouts
        case joinYourFriends
        case friendActivity
        case contentCard(String)
    }

    var id: ID {
        switch self {
        case .upcomingWorkouts:
            .upcomingWorkouts
        case .joinYourFriends:
            .joinYourFriends
        case .friendActivity:
            .friendActivity
        case let .contentCard(viewData):
            .contentCard(viewData.id)
        }
    }

    var hasContent: Bool {
        switch self {
        case let .upcomingWorkouts(sections):
            sections.contains { !$0.classes.isEmpty }
        case let .joinYourFriends(friendClasses):
            !friendClasses.isEmpty
        case let .friendActivity(activities):
            !activities.isEmpty
        case .contentCard:
            true
        }
    }
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

extension HomeModuleViewData {
    /// Values from home-sample.json with fixed date labels and bundled images for previews and snapshots.
    static func mockData() -> [Self] {
        [
            .upcomingWorkouts([
                .init(
                    title: "Friday, 11 September 2026", // Use dynamic dates
                    classes: [
                        .init(
                            id: "love2dance-20260911-1730",
                            className: "Love2Dance",
                            instructorName: "Eva",
                            location: "Ringnes Park",
                            time: "17:30",
                            duration: "60 min",
                            bookingState: .init(
                                message: "Booked",
                                imageName: "checkmark",
                                foregroundColor: .success
                            )
                        )
                    ]
                ),
                .init(
                    title: "Saturday, 12 September 2026",
                    classes: [
                        .init(
                            id: "rowing-20260912-1830",
                            className: "Rowing",
                            instructorName: "Erling",
                            location: "Ringnes Park",
                            time: "18:30",
                            duration: "30 min",
                            bookingState: .init(
                                message: "Booked",
                                imageName: "checkmark",
                                foregroundColor: .success
                            )
                        )
                    ]
                ),
                .init(
                    title: "Sunday, 13 September 2026",
                    classes: [
                        .init(
                            id: "yoga-flow-20260913-1000",
                            className: "Yoga Flow",
                            instructorName: "Ingrid",
                            location: "Majorstuen",
                            time: "10:00",
                            duration: "60 min",
                            bookingState: .init(
                                message: "On the waiting list",
                                imageName: "clock",
                                foregroundColor: .waitingList
                            )
                        )
                    ]
                )
            ]),
            .friendActivity([
                .init(
                    id: "home-erik-rowing",
                    profilePicture: .image(Image(.homeErikPortrait)),
                    message: "**Erik Hansen** did **Rowing**",
                    time: "10 September at 06:41",
                    isLiked: false
                ),
                .init(
                    id: "home-nora-yoga",
                    profilePicture: .image(Image(.homeNoraPortrait)),
                    message: "**Nora Johansen** did **Yoga Flow**",
                    time: "9 September at 19:15",
                    isLiked: true
                ),
                .init(
                    id: "home-sandre-cycling",
                    profilePicture: .image(Image(.homeSandrePortrait)),
                    message: "**Sandre Berg** did **Cycling Interval**",
                    time: "9 September at 17:30",
                    isLiked: false
                ),
                .init(
                    id: "home-amina-strength",
                    profilePicture: .image(Image(.homeAminaPortrait)),
                    message: "**Amina Larsen** did **Full Body Strength**",
                    time: "9 September at 12:45",
                    isLiked: true
                ),
                .init(
                    id: "home-mikkel-dance",
                    profilePicture: .image(Image(.homeMikkelPortrait)),
                    message: "**Mikkel Solberg** did **Love2Dance**",
                    time: "8 September at 18:30",
                    isLiked: false
                )
            ]),
            .joinYourFriends([
                .init(
                    id: "home-sandre-cycling-class",
                    friendInfo: .init(
                        profileImage: .image(Image(.homeSandrePortrait)),
                        message: "Sandre is going"
                    ),
                    groupClass: .init(
                        id: "cycling-20260911-1630",
                        className: "Cycling Interval",
                        date: "11 September at 16:30",
                        location: "Akersgata",
                        duration: "45 min",
                        bookingState: .notBooked,
                        backgroundImage: .image(Image(.bookCyclingInterval))
                    )
                ),
                .init(
                    id: "home-nora-yoga-class",
                    friendInfo: .init(
                        profileImage: .image(Image(.homeNoraPortrait)),
                        message: "Nora is going"
                    ),
                    groupClass: .init(
                        id: "yoga-morning-20260912-0900",
                        className: "Morning Yoga",
                        date: "12 September at 09:00",
                        location: "Majorstuen",
                        duration: "60 min",
                        bookingState: .notBooked,
                        backgroundImage: .image(Image(.bookMorningYoga))
                    )
                ),
                .init(
                    id: "home-amina-strength-class",
                    friendInfo: .init(
                        profileImage: .image(Image(.homeAminaPortrait)),
                        message: "Amina is going"
                    ),
                    groupClass: .init(
                        id: "strength-express-20260912-1200",
                        className: "Strength Express",
                        date: "12 September at 12:00",
                        location: "Nydalen",
                        duration: "30 min",
                        bookingState: .notBooked,
                        backgroundImage: .image(Image(.bookStrengthExpress))
                    )
                ),
                .init(
                    id: "home-mikkel-dance-class",
                    friendInfo: .init(
                        profileImage: .image(Image(.homeMikkelPortrait)),
                        message: "Mikkel is going"
                    ),
                    groupClass: .init(
                        id: "dance-energy-20260913-1600",
                        className: "Dance Energy",
                        date: "13 September at 16:00",
                        location: "Ringnes Park",
                        duration: "50 min",
                        bookingState: .notBookedOnWaitingList,
                        backgroundImage: .image(Image(.bookDanceEnergy))
                    )
                )
            ]),
            .contentCard(.init(
                id: "home-objectives",
                title: "What are your objectives?",
                text: """
                Build strength, find your rhythm, or make more time for yourself. \
                Explore classes that fit your goals and plan your next workout with a friend.
                """,
                image: .image(Image(.bookFeaturedContent))
            ))
        ]
    }
}
