import Tagged
import SwiftUI

struct GroupClassViewData: Equatable {
    let id: GroupClassID
    let className: String
    let backgroundImage: ImageViewData?
    let description: String
    let intensity: ClassIntensity
    let categoryName: String
    let categoryImage: ImageViewData?

    let date: String
    let duration: String
    let location: String
    let room: String
    let instructorName: String

    let bookingState: BookingState
    let bookedSpots: Int
    let capacity: Int
    var availableSpots: Int { max(0, capacity - bookedSpots) }

    let attendingFriends: [AttendingFriend]

    let similarClasses: [GroupClassRowViewData]

    struct AttendingFriend: Identifiable, Equatable {
        let id: MemberID
        let profilePicture: URL?
        let fullName: String
        let bookingState: BookingState
    }

    var bookedCapacityLabel: String {
        "\(bookedSpots)/\(capacity)"
    }
}

extension GroupClassViewData.AttendingFriend {
    init(dto: FriendAttending) {
        self.init(
            id: dto.member.id,
            profilePicture: dto.member.profilePicture,
            fullName: "\(dto.member.firstName) \(dto.member.lastName)",
            bookingState: dto.bookingState
        )
    }

    static func previewValue(
        id: MemberID = .previewValue(),
        profilePicture: URL? = nil,
        fullName: String = "Tony Stark",
        bookingState: BookingState = .booked
    ) -> Self {
        .init(
            id: id,
            profilePicture: profilePicture,
            fullName: fullName,
            bookingState: bookingState
        )
    }
}

extension GroupClassViewData {
    init(dto: GroupClass) {
        let intensity: ClassIntensity
        switch dto.intensity {
        case .low:
            intensity = .light
        case .medium:
            intensity = .moderate
        case .high:
            intensity = .intense
        }

        self.init(
            id: dto.id,
            className: dto.name,
            backgroundImage: .remote(from: dto.imageURL),
            description: dto.description,
            intensity: intensity,
            categoryName: "Group Class",
            categoryImage: .remote(from: dto.imageURL),
            date: dto.startTime.formatted(date: .abbreviated, time: .shortened),
            duration: dto.durationInMinutes.formatted() + " min",
            location: dto.gym.name,
            room: dto.room ?? "",
            instructorName: "\(dto.instructor.firstName) \(dto.instructor.lastName)",
            bookingState: dto.bookingState,
            bookedSpots: max(0, dto.capacity - dto.availableSpots),
            capacity: dto.capacity,
            attendingFriends: dto.friendsAttending.map { .init(dto: $0) },
            similarClasses: dto.similarClasses.map { .init(dto: $0) }
        )
    }

    static func previewValue(
        id: GroupClassID = .previewValue(),
        className: String = "Performance Strength",
        backgroundImage: ImageViewData? = .image(Image(.crossfit)),
        description: String = """
            Challenge your endurance in an energizing indoor cycling session. Alternate focused intervals with recovery periods, guided by your instructor and motivating music. Adjust the resistance to suit your experience and enjoy training together.
        """,
        intensity: ClassIntensity = .moderate,
        categoryName: String = "Strength",
        categoryImage: ImageViewData? = .image(Image(.lift)),
        date: String = "Sept 14, 14:15",
        duration: String = "45 min",
        location: String = "Oslo",
        room: String = "Room 2",
        instructorName: String = "Thea Kristoffersen",
        bookingState: BookingState = .notBooked,
        bookedSpots: Int = 22,
        capacity: Int = 30,
        attendingFriends: [AttendingFriend] = [
            .previewValue(fullName: "Mark"),
            .previewValue(fullName: "Robert"),
        ],
        similarClasses: [GroupClassRowViewData] = [
            .previewValue()
        ]
    ) -> Self {
        .init(
            id: id,
            className: className,
            backgroundImage: backgroundImage,
            description: description,
            intensity: intensity,
            categoryName: categoryName,
            categoryImage: categoryImage,
            date: date,
            duration: duration,
            location: location,
            room: room,
            instructorName: instructorName,
            bookingState: bookingState,
            bookedSpots: bookedSpots,
            capacity: capacity,
            attendingFriends: attendingFriends,
            similarClasses: similarClasses
        )
    }
}
