//
//  SocialActivityRow.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 04/09/2026.
//

import SwiftUI
import Tagged

struct SocialActivityRowViewData: Identifiable, Equatable {
    let id: SocialActivityID
    let profilePicture: ImageViewData?
    let message: LocalizedStringKey
    let time: String
    let isLiked: Bool
}

extension SocialActivityRowViewData {
    init(dto: SocialActivity) {
        self.init(
            id: dto.id,
            profilePicture: .remote(from: dto.member.profilePicture),
            message: LocalizedStringKey(dto.message),
            time: dto.date.formatted(.relative(presentation: .named, unitsStyle: .wide)),
            isLiked: dto.isLiked
        )
    }

    static func previewValue(
        id: SocialActivityID = "preview-social-activity",
        profilePicture: ImageViewData? = .image(Image(.lift)),
        message: LocalizedStringKey = "**Erling Haaland** did **Rowing**",
        time: String = "3 hours ago",
        isLiked: Bool = false
    ) -> Self {
        .init(
            id: id,
            profilePicture: profilePicture,
            message: message,
            time: time,
            isLiked: isLiked
        )
    }
}

struct SocialActivityRow: View {
    let viewData: SocialActivityRowViewData
    @ScaledMetric(relativeTo: .body) private var avatarSize: CGFloat = 44

    var body: some View {
        HStack(spacing: .spacingS) {
            Color.secondary
                .overlay {
                    CustomAsyncImage(state: viewData.profilePicture) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                }
                .frame(width: avatarSize, height: avatarSize)
                .clipShape(Circle())
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: .spacingXXS) {
                Text(viewData.message)
                    .font(.body)
                Text(viewData.time)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "hand.thumbsup")
                .font(.headline)
                .foregroundStyle(.accent)
                .padding(.spacingXS)
                .symbolVariant(viewData.isLiked ? .fill : .none)
                .accessibilityLabel(viewData.isLiked ? "Liked" : "Not liked")
        }
        .padding(.vertical, .spacingS)
        .accessibilityElement(children: .combine)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        SocialActivityRow(viewData: .previewValue(id: "preview-activity-1"))
        SocialActivityRow(viewData: .previewValue(id: "preview-activity-2", isLiked: true))
    }
    .padding()
}
