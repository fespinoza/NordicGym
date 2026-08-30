//
//  FriendActivityCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 10/09/2026.
//

import SwiftUI

struct FriendActivityCard: View {
    let rows: [SocialActivityRowViewData]

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingM) {
            ForEach(rows) { row in
                SocialActivityRow(viewData: row)
            }
        }
        .cardStyle()
    }
}

#Preview {
    FriendActivityCard(
        rows: [
            .previewValue(),
            .previewValue(),
            .previewValue(),
        ]
    )
    .padding()
}
