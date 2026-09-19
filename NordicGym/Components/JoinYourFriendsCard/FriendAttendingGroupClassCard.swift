//
//  FriendAttendingGroupClassCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 10/09/2026.
//

import SwiftUI
import Tagged

struct FriendAttendingViewData: Identifiable, Equatable {
    let id: String
    let friendInfo: FriendInfo
    let groupClass: GroupClassCardViewData

    struct FriendInfo: Equatable {
        let profileImage: ImageViewData?
        let message: String
    }
}

struct FriendAttendingGroupClassCard: View {
    let viewData: FriendAttendingViewData
    @ScaledMetric(relativeTo: .body) private var avatarSize: CGFloat = 32

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingS) {
            HStack(spacing: .spacingXS) {
                CustomAsyncImage(state: viewData.friendInfo.profileImage) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .clipShape(Circle())
                .frame(width: avatarSize, height: avatarSize)
                .accessibilityHidden(true)

                Text(viewData.friendInfo.message)
                    .font(.subheadline.weight(.semibold))
            }

            GroupClassCard(viewData: viewData.groupClass)
        }
        .homeCardStyle(contentPadding: .spacingXS)
    }
}

#Preview {
    FriendAttendingGroupClassCard(viewData: .previewValue())
}

extension FriendAttendingViewData {
    init(dto: FriendAttendingGroupClass) {
        self.init(
            id: "\(dto.friend.id.rawValue)-\(dto.groupClass.id.rawValue)",
            friendInfo: .init(
                profileImage: .remote(from: dto.friend.profilePicture),
                message: "\(dto.friend.firstName) is going"
            ),
            groupClass: .init(dto: dto.groupClass)
        )
    }

    static func previewValue(
        id: String = "preview-friend-attending",
        friendInfo: FriendInfo = .previewValue(),
        groupClass: GroupClassCardViewData = .previewValue()
    ) -> Self {
        .init(
            id: id,
            friendInfo: friendInfo,
            groupClass: groupClass
        )
    }
}

extension FriendAttendingViewData.FriendInfo {
    static func previewValue(
        profileImage: ImageViewData? = .image(Image(.groupClass)),
        message: String = "Snadre is going"
    ) -> Self {
        .init(
            profileImage: profileImage,
            message: message
        )
    }
}
