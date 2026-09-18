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
