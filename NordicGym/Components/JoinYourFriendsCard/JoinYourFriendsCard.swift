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
    }
}

#Preview {
    JoinYourFriendsCard(friendClasses: [
        .previewValue(),
        .previewValue(),
        .previewValue(),
        .previewValue(),
    ])
}
