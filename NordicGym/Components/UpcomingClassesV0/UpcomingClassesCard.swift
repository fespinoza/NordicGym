//
//  UpcomingClassesCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 08/09/2026.
//

import SwiftUI

struct UpcomingClassesSectionViewData: Identifiable, Equatable {
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

                    VStack(alignment: .leading, spacing: .spacingM) {
                        ForEach(section.classes) { row in
                            GroupClassRow(viewData: row)
                        }
                    }
                }
            }
        }
        .cardStyle()
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

extension UpcomingClassesSectionViewData {
    static func previewValue(
        title: String = "Tomorrow",
        classes: [GroupClassRowViewData] = [.previewValue(), .previewValue()]
    ) -> Self {
        .init(
            title: title,
            classes: classes
        )
    }
}
