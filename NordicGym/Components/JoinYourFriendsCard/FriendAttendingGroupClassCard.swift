//
//  FriendAttendingGroupClassCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 10/09/2026.
//

import SwiftUI

struct FriendAttendingViewData: Identifiable {
    let id: UUID = .init()
    let friendInfo: FriendInfo
    let groupClass: GroupClassCardViewData

    struct FriendInfo {
        let profileImage: Image
        let message: String
    }
}

struct FriendAttendingGroupClassCard: View {
    let viewData: FriendAttendingViewData

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: .spacingXS) {
                viewData.friendInfo.profileImage
                    .resizable()
                    .scaledToFill()
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
        profileImage: Image = Image(.lift),
        message: String = "Snadre is going"
    ) -> Self {
        .init(
            profileImage: profileImage,
            message: message
        )
    }
}
