//
//  SocialActivityRow.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 04/09/2026.
//

import SwiftUI

struct SocialActivityRowViewData: Identifiable, Equatable {
    let id: UUID = .init()
    let profilePicture: Image?
    let message: LocalizedStringKey
    let time: String
    let isLiked: Bool
}

extension SocialActivityRowViewData {
    init(dto: SocialActivity) {
        self.init(
            profilePicture: nil,
            message: LocalizedStringKey(dto.message),
            time: dto.date.formatted(.relative(presentation: .named, unitsStyle: .wide)),
            isLiked: dto.isLiked
        )
    }

    static func previewValue(
        profilePicture: Image? = nil,
        message: LocalizedStringKey = "**Erling Haaland** did **Rowing**",
        time: String = "3 hours ago",
        isLiked: Bool = false
    ) -> Self {
        .init(
            profilePicture: profilePicture,
            message: message,
            time: time,
            isLiked: isLiked
        )
    }
}

struct SocialActivityRow: View {
    let viewData: SocialActivityRowViewData

    var body: some View {
        HStack(spacing: .spacingS) {
            Color.secondary
                .overlay {
                    if let profilePicture = viewData.profilePicture {
                        profilePicture
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 48, height: 48)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(viewData.message)
                Text(viewData.time).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "hand.thumbsup")
                .bold()
                .foregroundStyle(.accent)
                .padding(.spacingM)
                .symbolVariant(viewData.isLiked ? .fill : .none)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        SocialActivityRow(viewData: .previewValue(profilePicture: Image(.lift)))
        SocialActivityRow(viewData: .previewValue(isLiked: true))
    }
    .padding()
}
