//
//  FriendActivityCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 10/09/2026.
//

import SwiftUI
import Tagged

struct FriendActivityCard: View {
    let rows: [SocialActivityRowViewData]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(rows) { row in
                SocialActivityRow(viewData: row)

                if row.id != rows.last?.id {
                    Divider()
                }
            }
        }
        .homeCardStyle(contentPadding: .spacingS)
    }
}

#Preview {
    FriendActivityCard(
        rows: [
            .previewValue(id: "preview-activity-1"),
            .previewValue(id: "preview-activity-2"),
            .previewValue(id: "preview-activity-3"),
        ]
    )
    .padding()
}
