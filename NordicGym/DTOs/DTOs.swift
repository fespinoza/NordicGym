//
//  DTOs.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 08/09/2026.
//

import Foundation
import Tagged

typealias MemberID = Tagged<Member, String>

/// Data Transfer Object (without ID)
typealias BasicDTO = Codable & Hashable & Sendable

/// Data Transfer Object - Swift representations for JSON data coming from the server
typealias DTO = Identifiable & BasicDTO

struct Member: DTO {
    let id: MemberID
    let firstName: String
    let lastName: String
    let profilePicture: URL?
}

typealias SocialActivityID = Tagged<SocialActivity, String>

struct SocialActivity: DTO {
    let id: SocialActivityID
    let member: Member
    let message: String
    let date: Date
    let isLiked: Bool
}

typealias GroupClassID = Tagged<GroupClass, String>

struct GroupClass: DTO {
    let id: GroupClassID

    let gym: Gym
    let room: String?
    let instructor: Instructor
    let startTime: Date
    let durationInMinutes: Int
    let bookingState: BookingState
    let availableSpots: Int
    let capacity: Int

    let friendsAttending: [FriendAttending]

    let similarClasses: [UpcomingGroupClass]

    let name: String
    let description: String
    let imageURL: URL?
    let intensity: Intensity

    enum Intensity: String, Codable {
        case low
        case medium
        case high
    }
}

struct FriendAttending: DTO {
    var id: MemberID { member.id }
    let member: Member
    let bookingState: BookingState
}

typealias GymID = Tagged<Gym, String>
struct Gym: DTO {
    let id: GymID
    let name: String
}

typealias InstructorID = Tagged<Instructor, String>

struct Instructor: DTO {
    let id: InstructorID
    let firstName: String
    let lastName: String
}

struct UpcomingGroupClass: DTO {
    let id: GroupClassID
    let name: String
    let instructorName: String
    let location: String
    let startTime: Date
    let durationInMinutes: Int
    let bookingState: BookingState
    let availableSpots: Int
    let imageURL: URL?
}

enum BookingState: String, BasicDTO, CaseIterable {
    case notBooked
    case booked
    case bookedOnWaitingList
    case notBookedOnWaitingList
}

struct FeaturedContent: DTO {
    let id: UUID
    let title: String
    let message: String
    let imageURL: URL?
}

struct FriendAttendingGroupClass: DTO {
    var id: String { "\(friend.id)-\(groupClass.id)" }
    let friend: Member
    let groupClass: UpcomingGroupClass
}

enum HomeModule: PolymorphicDTO {
    static func dtoType(for typeName: String) throws -> HomeModuleType {
        guard let type = HomeModuleType(rawValue: typeName) else {
            throw PolymorphicDecodingError.unknownType(typeName)
        }
        return type
    }

    static func tryDecode(dtoType: HomeModuleType, container: DecodingContainer) throws -> HomeModule {
        switch dtoType {
        case .featuredContent:
            let content = try container.decode(FeaturedContent.self, forKey: .content)
            return .featuredContent(content)

        case .friendActivity:
            let content = try container.decode([SocialActivity].self, forKey: .content)
            return .friendActivity(content)

        case .upcomingClasses:
            let content = try container.decode([UpcomingGroupClass].self, forKey: .content)
            return .upcomingClasses(content)

        case .joinYourFriends:
            let content = try container.decode([FriendAttendingGroupClass].self, forKey: .content)
            return .joinYourFriends(content)
        }
    }

    typealias DTOTypeDeclaration = HomeModuleType

    enum HomeModuleType: String {
        case featuredContent
        case friendActivity
        case upcomingClasses
        case joinYourFriends
    }

    case featuredContent(FeaturedContent)
    case friendActivity([SocialActivity])
    case upcomingClasses([UpcomingGroupClass])
    case joinYourFriends([FriendAttendingGroupClass])
}

struct HomeContent: Decodable {
    let items: [HomeModule]
}

struct BookContent: Decodable {
    let items: [BookModule]
}

enum BookModule: PolymorphicDTO {
    static func dtoType(for typeName: String) throws -> BookModuleType {
        guard let type = BookModuleType(rawValue: typeName) else {
            throw PolymorphicDecodingError.unknownType(typeName)
        }

        return type
    }

    static func tryDecode(dtoType: BookModuleType, container: DecodingContainer) throws -> BookModule {
        switch dtoType {
        case .recommendedClasses:
            let content = try container.decode([UpcomingGroupClass].self, forKey: .content)
            return .recommendedClasses(content)

        case .featuredContent:
            let content = try container.decode(FeaturedContent.self, forKey: .content)
            return .featuredContent(content)

        case .challenges:
            let content = try container.decode([Challenge].self, forKey: .content)
            return .challenges(content)
        }
    }

    typealias DTOTypeDeclaration = BookModuleType


    case recommendedClasses([UpcomingGroupClass])
    case featuredContent(FeaturedContent)
    case challenges([Challenge])

    enum BookModuleType: String {
        case recommendedClasses
        case featuredContent
        case challenges
    }


}

typealias ChallengeID = Tagged<Challenge, String>

struct Challenge: DTO {
    let id: ChallengeID
    let title: String
    let text: String
    let lastStartTime: Date
    let badgeColor: String
}

// MARK: - Polymorphism

/// A common way to represent polymorphic entities in JSON.
/// the mandatory property for the object will be
/// - `type`: String name of the concrete type
/// - `content`: Object that contains the concrete properties of the declared type
///
/// Example: an polymorphic array will have the shape
/// ```json
/// [
///   {
///     "type": "typeA",
///     "content": {}
///   },
///   {
///     "type": "typeB",
///     "content": {}
///   }
/// ]
/// ```
protocol PolymorphicDTO: Decodable {
    typealias DecodingContainer = KeyedDecodingContainer<PolymorphicDtoCodingKeys>
    associatedtype DTOTypeDeclaration

    static func dtoType(for typeName: String) throws -> DTOTypeDeclaration

    static func tryDecode(dtoType: DTOTypeDeclaration, container: DecodingContainer) throws -> Self
}

public enum PolymorphicDecodingError: Error {
    case unknownType(_ name: String)
}

public enum PolymorphicDtoCodingKeys: String, CodingKey {
    case type
    case content
}

extension PolymorphicDTO {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PolymorphicDtoCodingKeys.self)
        let typeName = try container.decode(String.self, forKey: .type)

        let dtoType = try Self.dtoType(for: typeName)

        let dto = try Self.tryDecode(dtoType: dtoType, container: container)
        self = dto
    }
}
