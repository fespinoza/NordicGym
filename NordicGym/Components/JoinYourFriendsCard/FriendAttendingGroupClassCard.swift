//
//  FriendAttendingGroupClassCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 10/09/2026.
//

import SwiftUI

struct FriendAttendingViewData: Identifiable, Equatable {
    let id: UUID = .init()
    let friendInfo: FriendInfo
    let groupClass: GroupClassCardViewData

    struct FriendInfo: Equatable {
        let profileImageURL: URL?
        let message: String
    }
}

struct FriendAttendingGroupClassCard: View {
    let viewData: FriendAttendingViewData

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: .spacingXS) {
                AsyncImage(url: viewData.friendInfo.profileImageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .clipShape(Circle())
                .frame(width: 30, height: 30)

                Text(viewData.friendInfo.message)
            }

            GroupClassCard(viewData: viewData.groupClass)
        }
        .padding(.spacingXS)
        .background {
            RoundedRectangle(cornerRadius: .cornerRadiusM + .spacingXS)
                .foregroundStyle(Color.joinYourFriendsBackground)
        }
    }
}

#Preview {
    FriendAttendingGroupClassCard(viewData: .previewValue())
}

extension FriendAttendingViewData {
    init(dto: FriendAttendingGroupClass) {
        self.init(
            friendInfo: .init(
                profileImageURL: dto.friend.profilePicture,
                message: "\(dto.friend.firstName) is going"
            ),
            groupClass: .init(dto: dto.groupClass)
        )
    }

    static func previewValue(
        friendInfo: FriendInfo = .previewValue(),
        groupClass: GroupClassCardViewData = .previewValue()
    ) -> Self {
        .init(
            friendInfo: friendInfo,
            groupClass: groupClass
        )
    }
}

extension FriendAttendingViewData.FriendInfo {
    static func previewValue(
        profileImageURL: URL? = nil,
        message: String = "Snadre is going"
    ) -> Self {
        .init(
            profileImageURL: profileImageURL,
            message: message
        )
    }
}
