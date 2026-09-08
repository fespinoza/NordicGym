//
//  UpcomingClassesCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 08/09/2026.
//

import SwiftUI

struct UpcomingClassesSectionViewData: Identifiable {
    let id: UUID = .init()
    let title: String
    let classes: [GroupClassRowViewData]
}

struct UpcomingClassesCard: View {
    let sections: [UpcomingClassesSectionViewData]

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingL) {
            ForEach(sections) { section in
                VStack(alignment: .leading) {
                    Text(section.title)
                        .font(.caption.bold())

                    VStack(alignment: .leading) {
                        ForEach(section.classes) { row in
                            GroupClassRow(viewData: row)
                        }
                    }
                }
            }
        }
        .padding(.spacingM)
        .background {
            RoundedRectangle(cornerRadius: .cornerRadiusM)
                .foregroundStyle(Color.cardBackground)

        }
    }
}

#Preview {
    UpcomingClassesCard(
        sections: [
            .init(title: "Tomorrow", classes: [.previewValue(), .previewValue()]),
            .init(title: "Saturday", classes: [.previewValue()]),
        ]
    )
    .padding()
}
