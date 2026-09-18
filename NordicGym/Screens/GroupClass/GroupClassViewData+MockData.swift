import SwiftUI
import Tagged

extension GroupClassViewData {
    /// Defaults from group-class-cycling-20260911-1630.json, with fixed date labels and bundled class images.
    static func mockCyclingInterval(
        id: GroupClassID = "cycling-20260911-1630",
        className: String = "Cycling Interval",
        backgroundImage: ImageViewData? = .image(Image(.bookCyclingInterval)),
        description: String = """
            Build endurance with energizing cycling intervals. Adjust your resistance as Alex guides you through climbs, \
            sprints, and recovery periods.
        """,
        intensity: ClassIntensity = .intense,
        categoryName: String = "Group Class",
        categoryImage: ImageViewData? = .image(Image(.bookCyclingInterval)),
        date: String = "11 September 2026 at 16:30",
        duration: String = "45 min",
        location: String = "Akersgata",
        room: String = "Cycling Studio",
        instructorName: String = "Alex Berg",
        bookingState: BookingState = .notBooked,
        bookedSpots: Int = 18,
        capacity: Int = 24,
        attendingFriends: [AttendingFriend] = [
            .init(
                id: "member-sandre",
                profilePicture: URL(string: "https://randomuser.me/api/portraits/men/46.jpg"),
                fullName: "Sandre Berg",
                bookingState: .booked
            )
        ],
        similarClasses: [GroupClassRowViewData] = [
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

    /// Defaults from group-class-dance-energy-20260913-1600.json, with fixed date labels and bundled class images.
    static func mockDanceEnergy(
        id: GroupClassID = "dance-energy-20260913-1600",
        className: String = "Dance Energy",
        backgroundImage: ImageViewData? = .image(Image(.bookDanceEnergy)),
        description: String = """
            Move to upbeat music in an energetic dance workout. Follow Eva through easy-to-learn combinations that build \
            coordination and get your heart pumping.
        """,
        intensity: ClassIntensity = .intense,
        categoryName: String = "Group Class",
        categoryImage: ImageViewData? = .image(Image(.bookDanceEnergy)),
        date: String = "13 September 2026 at 16:00",
        duration: String = "50 min",
        location: String = "Ringnes Park",
        room: String = "Dance Studio",
        instructorName: String = "Eva Larsen",
        bookingState: BookingState = .notBookedOnWaitingList,
        bookedSpots: Int = 30,
        capacity: Int = 30,
        attendingFriends: [AttendingFriend] = [
            .init(
                id: "member-mikkel",
                profilePicture: URL(string: "https://randomuser.me/api/portraits/men/75.jpg"),
                fullName: "Mikkel Solberg",
                bookingState: .booked
            )
        ],
        similarClasses: [GroupClassRowViewData] = [
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

    /// Defaults from group-class-love2dance-20260911-1730.json, with fixed date labels and bundled class images.
    static func mockLove2Dance(
        id: GroupClassID = "love2dance-20260911-1730",
        className: String = "Love2Dance",
        backgroundImage: ImageViewData? = .image(Image(.bookDanceEnergy)),
        description: String = """
            Enjoy a full hour of music and movement with Eva. Explore fun dance combinations and build your stamina in a \
            welcoming class for all experience levels.
        """,
        intensity: ClassIntensity = .moderate,
        categoryName: String = "Group Class",
        categoryImage: ImageViewData? = .image(Image(.bookDanceEnergy)),
        date: String = "11 September 2026 at 17:30",
        duration: String = "60 min",
        location: String = "Ringnes Park",
        room: String = "Dance Studio",
        instructorName: String = "Eva Larsen",
        bookingState: BookingState = .booked,
        bookedSpots: Int = 27,
        capacity: Int = 30,
        attendingFriends: [AttendingFriend] = [],
        similarClasses: [GroupClassRowViewData] = [
            .init(
                id: "dance-energy-20260913-1600",
                className: "Dance Energy",
                instructorName: "Eva",
                location: "Ringnes Park",
                time: "16:00",
                duration: "50 min",
                bookingState: .init(
                    message: "Join the waiting list",
                    imageName: "clock",
                    foregroundColor: .waitingList
                )
            )
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

    /// Defaults from group-class-rowing-20260912-1830.json, with fixed date labels and bundled class images.
    static func mockRowing(
        id: GroupClassID = "rowing-20260912-1830",
        className: String = "Rowing",
        backgroundImage: ImageViewData? = .image(Image(.homeRowing)),
        description: String = """
            Improve your rowing technique and endurance with a mix of intervals and steady efforts. Erling will help you \
            find a strong rhythm and adjust the workout to your level.
        """,
        intensity: ClassIntensity = .intense,
        categoryName: String = "Group Class",
        categoryImage: ImageViewData? = .image(Image(.homeRowing)),
        date: String = "12 September 2026 at 18:30",
        duration: String = "30 min",
        location: String = "Ringnes Park",
        room: String = "Rowing Studio",
        instructorName: String = "Erling Johansen",
        bookingState: BookingState = .booked,
        bookedSpots: Int = 8,
        capacity: Int = 16,
        attendingFriends: [AttendingFriend] = [],
        similarClasses: [GroupClassRowViewData] = [
            .init(
                id: "strength-express-20260912-1200",
                className: "Strength Express",
                instructorName: "Jonas",
                location: "Nydalen",
                time: "12:00",
                duration: "30 min",
                bookingState: .init(
                    message: "1 spots available",
                    imageName: "plus",
                    foregroundColor: .accent
                )
            )
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

    /// Defaults from group-class-strength-express-20260912-1200.json, with fixed date labels and bundled class images.
    static func mockStrengthExpress(
        id: GroupClassID = "strength-express-20260912-1200",
        className: String = "Strength Express",
        backgroundImage: ImageViewData? = .image(Image(.bookStrengthExpress)),
        description: String = """
            Make the most of 30 minutes with a focused full-body strength workout. Jonas will help you choose weights and \
            build confidence with each exercise.
        """,
        intensity: ClassIntensity = .moderate,
        categoryName: String = "Group Class",
        categoryImage: ImageViewData? = .image(Image(.bookStrengthExpress)),
        date: String = "12 September 2026 at 12:00",
        duration: String = "30 min",
        location: String = "Nydalen",
        room: String = "Room 2",
        instructorName: String = "Jonas Hansen",
        bookingState: BookingState = .notBooked,
        bookedSpots: Int = 19,
        capacity: Int = 20,
        attendingFriends: [AttendingFriend] = [
            .init(
                id: "member-amina",
                profilePicture: URL(string: "https://randomuser.me/api/portraits/women/68.jpg"),
                fullName: "Amina Larsen",
                bookingState: .booked
            )
        ],
        similarClasses: [GroupClassRowViewData] = [
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

    /// Defaults from group-class-yoga-flow-20260913-1000.json, with fixed date labels and bundled class images.
    static func mockYogaFlow(
        id: GroupClassID = "yoga-flow-20260913-1000",
        className: String = "Yoga Flow",
        backgroundImage: ImageViewData? = .image(Image(.bookMorningYoga)),
        description: String = """
            Connect breath and movement through a flowing sequence of yoga poses. Ingrid will offer variations to help you \
            develop balance, mobility, and strength.
        """,
        intensity: ClassIntensity = .moderate,
        categoryName: String = "Group Class",
        categoryImage: ImageViewData? = .image(Image(.bookMorningYoga)),
        date: String = "13 September 2026 at 10:00",
        duration: String = "60 min",
        location: String = "Majorstuen",
        room: String = "Mind and Body Studio",
        instructorName: String = "Ingrid Solberg",
        bookingState: BookingState = .bookedOnWaitingList,
        bookedSpots: Int = 20,
        capacity: Int = 20,
        attendingFriends: [AttendingFriend] = [],
        similarClasses: [GroupClassRowViewData] = [
            .init(
                id: "yoga-morning-20260912-0900",
                className: "Morning Yoga",
                instructorName: "Ingrid",
                location: "Majorstuen",
                time: "09:00",
                duration: "60 min",
                bookingState: .init(
                    message: "12 spots available",
                    imageName: "plus",
                    foregroundColor: .accent
                )
            )
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

    /// Defaults from group-class-yoga-morning-20260912-0900.json, with fixed date labels and bundled class images.
    static func mockMorningYoga(
        id: GroupClassID = "yoga-morning-20260912-0900",
        className: String = "Morning Yoga",
        backgroundImage: ImageViewData? = .image(Image(.bookMorningYoga)),
        description: String = """
            Start your day with gentle movement, breathing, and stretching. Ingrid will guide you through a balanced \
            practice with options for every experience level.
        """,
        intensity: ClassIntensity = .light,
        categoryName: String = "Group Class",
        categoryImage: ImageViewData? = .image(Image(.bookMorningYoga)),
        date: String = "12 September 2026 at 09:00",
        duration: String = "60 min",
        location: String = "Majorstuen",
        room: String = "Mind and Body Studio",
        instructorName: String = "Ingrid Solberg",
        bookingState: BookingState = .notBooked,
        bookedSpots: Int = 8,
        capacity: Int = 20,
        attendingFriends: [AttendingFriend] = [
            .init(
                id: "member-nora",
                profilePicture: URL(string: "https://randomuser.me/api/portraits/women/44.jpg"),
                fullName: "Nora Johansen",
                bookingState: .booked
            )
        ],
        similarClasses: [GroupClassRowViewData] = [
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
