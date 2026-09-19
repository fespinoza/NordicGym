//
//  JoinYourFriendsCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 10/09/2026.
//

import SwiftUI

struct JoinYourFriendsCard: View {
    let friendClasses: [FriendAttendingViewData]

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: .spacingM) {
                ForEach(friendClasses) { cardData in
                    FriendAttendingGroupClassCard(viewData: cardData)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    JoinYourFriendsCard(friendClasses: [
        .previewValue(id: "preview-friend-1"),
        .previewValue(id: "preview-friend-2"),
        .previewValue(id: "preview-friend-3"),
        .previewValue(id: "preview-friend-4"),
    ])
}
