//
//  ServiceButton.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 07/09/2026.
//

import SwiftUI

struct ServiceButtonViewData {
    let iconName: String
    let title: String
}

struct ServiceButton: View {
    let viewData: ServiceButtonViewData

    private let iconAreaSize: CGFloat = 50

    var body: some View {
        Button(action: {}) {
            VStack {
                Image(systemName: viewData.iconName)
                    .frame(width: iconAreaSize, height: iconAreaSize)
                    .background {
                        RoundedRectangle(cornerRadius: .cornerRadiusM)
                            .foregroundStyle(Color.accent)
                    }
                    .foregroundStyle(.onAccent)

                Text(viewData.title)
                    .bold()
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ServiceButton(viewData: .previewValue())
}

extension ServiceButtonViewData {
    static func previewValue(
        iconName: String = "person.3.fill",
        title: String = "Group Classes"
    ) -> Self {
        .init(
            iconName: iconName,
            title: title
        )
    }
}
