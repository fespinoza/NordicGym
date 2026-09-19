//
//  JoinChallengeCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 12/09/2026.
//

import SwiftUI

struct JoinChallengeCardViewData: Equatable {
    let timeRemaining: String
    let badgeColor: Color
    let title: String
    let text: String
}

extension JoinChallengeCardViewData {
    init(dto: Challenge) {
        self.init(
            timeRemaining: dto.lastStartTime.formatted(.relative(presentation: .named, unitsStyle: .wide)),
            badgeColor: Color.accent, // TODO: make colors from hex and use dto.badgeColor
            title: dto.title,
            text: dto.text
        )
    }

    static func previewValue(
        timeRemaining: String = "38 days left",
        badgeColor: Color = .red,
        title: String = "Choose to move",
        text: String = "Train 8 times at our clubs"
    ) -> Self {
        .init(
            timeRemaining: timeRemaining,
            badgeColor: badgeColor,
            title: title,
            text: text
        )
    }
}

struct JoinChallengeCard: View {
    let viewData: JoinChallengeCardViewData

    var body: some View {
        VStack {
            Spacer(minLength: 60)

            VStack(alignment: .center, spacing: .spacingXS) {
                Image(systemName: "medal.fill")
                    .font(.system(size: 54))
                    .padding(.spacingXS)
                    .background {
                        Circle()
                            .foregroundStyle(viewData.badgeColor)
                    }

                Text(viewData.title)
                    .bold()

                Text(viewData.text)

            }
            .multilineTextAlignment(.center)

            Spacer(minLength: 30)

            Button(action: {}) {
                Text("Join")
            }
            .buttonStyle(.borderedProminent)
            .tint(.accent)
        }
        .frame(maxWidth: 180)
        .fixedSize(horizontal: false, vertical: true)
        .cardStyle()
        .overlay(alignment: .topLeading) {
            Text(viewData.timeRemaining)
                .padding(.spacingXS)
                .foregroundStyle(.onAccent)
                .background {
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: .cornerRadiusS,
                        topTrailingRadius: .cornerRadiusS,
                        style: .continuous
                    )
                    .foregroundStyle(Color.accent)
                }
                .padding(.top, .spacingM)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    JoinChallengeCard(viewData: .previewValue())
        .padding()
}
