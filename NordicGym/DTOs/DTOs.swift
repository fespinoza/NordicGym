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
    let name: String
}

struct UpcomingGroupClass: DTO {
    let id: GroupClassID
    let name: String
    let instructorName: String
    let location: String
    let dateTime: Date
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
