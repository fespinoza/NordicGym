//
//  View-Styling.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 10/09/2026.
//

import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
        .padding(.spacingM)
        .font(.subheadline)
        .background {
            RoundedRectangle(cornerRadius: .cornerRadiusM)
                .foregroundStyle(Color.cardBackground)

        }
    }
}
