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

extension BookModuleViewData {
    /// Values from book-sample.json with fixed date labels and bundled images for previews and snapshots.
    static func mockData() -> [Self] {
        [
            .services([
                .init(iconName: "person.3.fill", title: "Group Class"),
                .init(iconName: "figure.strengthtraining.traditional", title: "Personal Trainer"),
                .init(iconName: "figure.flexibility", title: "Physiotherapy")
            ]),
            .recommendedClasses([
                .init(
                    id: "cycling-20260911-1630",
                    className: "Cycling Interval",
                    date: "11 September at 16:30",
                    location: "Akersgata",
                    duration: "45 min",
                    bookingState: .notBooked,
                    backgroundImage: nil// .image(Image(.bookCyclingInterval))
                ),
                .init(
                    id: "yoga-morning-20260912-0900",
                    className: "Morning Yoga",
                    date: "12 September at 09:00",
                    location: "Majorstuen",
                    duration: "60 min",
                    bookingState: .notBooked,
                    backgroundImage: nil//.image(Image(.bookMorningYoga))
                ),
                .init(
                    id: "strength-express-20260912-1200",
                    className: "Strength Express",
                    date: "12 September at 12:00",
                    location: "Nydalen",
                    duration: "30 min",
                    bookingState: .notBooked,
                    backgroundImage: nil//.image(Image(.bookStrengthExpress))
                ),
                .init(
                    id: "dance-energy-20260913-1600",
                    className: "Dance Energy",
                    date: "13 September at 16:00",
                    location: "Ringnes Park",
                    duration: "50 min",
                    bookingState: .notBookedOnWaitingList,
                    backgroundImage: nil//.image(Image(.bookDanceEnergy))
                )
            ]),
            .contentCard(.init(
                title: "Find your next favorite class",
                text: """
                Try something new this week. From cycling and strength to yoga and dance, \
                discover a class that fits your goals and book your next workout.
                """,
                image: .image(Image(.bookFeaturedContent))
            )),
            .challenges([
                .init(
                    timeRemaining: "Start by 23 October",
                    badgeColor: Color(red: 232 / 255.0, green: 93 / 255.0, blue: 117 / 255.0),
                    title: "Choose to move",
                    text: "Train 8 times at our clubs"
                ),
                .init(
                    timeRemaining: "Start by 15 October",
                    badgeColor: Color(red: 107 / 255.0, green: 142 / 255.0, blue: 123 / 255.0),
                    title: "Find your balance",
                    text: "Complete 6 yoga or Pilates classes"
                ),
                .init(
                    timeRemaining: "Start by 31 October",
                    badgeColor: Color(red: 113 / 255.0, green: 97 / 255.0, blue: 168 / 255.0),
                    title: "Stronger together",
                    text: "Join 10 group classes with your friends"
                )
            ])
        ]
    }

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
