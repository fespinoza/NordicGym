//
//  DTOs.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 08/09/2026.
//

import Foundation
import Tagged

typealias MemberID = Tagged<Member, String>

typealias BasicDTO = Codable & Hashable & Sendable
typealias DTO = Identifiable & BasicDTO

struct Member: DTO {
    let id: MemberID
    let firstName: String
    let lastName: String
    let profilePicture: URL?
}

struct SocialActivity: BasicDTO {
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
