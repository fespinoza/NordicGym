//
//  UpcomingClassesCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 08/09/2026.
//

import SwiftUI

struct UpcomingClassesSectionViewData: Identifiable, Equatable {
    let title: String
    let classes: [GroupClassRowViewData]

    var id: String { title }
}

struct UpcomingClassesCard: View {
    let sections: [UpcomingClassesSectionViewData]

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingL) {
            ForEach(sections) { section in
                UpcomingClassesSection(viewData: section)
            }
        }
        .homeCardStyle()
    }
}

private struct UpcomingClassesSection: View {
    let viewData: UpcomingClassesSectionViewData

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingS) {
            Text(viewData.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: 0) {
                ForEach(viewData.classes) { row in
                    GroupClassRow(viewData: row)

                    if row.id != viewData.classes.last?.id {
                        Divider()
                    }
                }
            }
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
