//
//  JoinChallengeCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 12/09/2026.
//

import SwiftUI

struct JoinChallengeCardViewData {
    let timeRemaining: String
    let title: String
    let text: String
}

extension JoinChallengeCardViewData {
    static func previewValue(
        timeRemaining: String = "38 days left",
        title: String = "Choose to move",
        text: String = "Train 8 times at our clubs"
    ) -> Self {
        .init(
            timeRemaining: timeRemaining,
            title: title,
            text: text
        )
    }
}

struct JoinChallengeCard: View {
    enum Size {
        case regular
        case compact
    }

    let viewData: JoinChallengeCardViewData
    var size: Size = .regular
    var onJoin: () -> Void = {}

    @ScaledMetric(relativeTo: .title2) private var fontSize: CGFloat = 26
    private var imageSize: CGFloat { size == .compact ? 84 : 132 }

    var body: some View {
        VStack(spacing: size == .compact ? .spacingM : .spacingXL) {
            Text(viewData.timeRemaining)
                .bold()
                .padding(.horizontal, .spacingXXS)
                .padding(.vertical, .spacingXXS)
                .foregroundStyle(.onAccent)
                .background {
                    RoundedRectangle(cornerRadius: .cornerRadiusM)
                        .foregroundStyle(Color.accentSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: size == .compact ? .spacingXS : .spacingM) {
                Image(systemName: "medal.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(size == .compact ? .spacingXS : .spacingM)
                    .frame(width: imageSize, height: imageSize)
                    .foregroundStyle(Color.accent)
                    .background { Circle().foregroundStyle(.white) }
                    .accessibilityHidden(true)

                VStack(spacing: .spacingXXXS) {
                    Text(viewData.title)
                        .bold()
                    Text(viewData.text)
                }
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
            }

            Button(action: onJoin) {
                Text("Join")
                    .bold()
            }
            .foregroundStyle(.onAccent)
            .buttonStyle(.borderedProminent)
            .tint(.accent)
            .buttonBorderShape(.capsule)
        }
        .font(size == .compact ? .callout : .system(size: fontSize))
        .padding(size == .compact ? .spacingXS : .spacingM)
        .frame(width: size == .compact ? 200 : 312)
        .frame(minHeight: size == .compact ? 278 : 432)
        .background { Color.cardBackground }
        .clipShape(RoundedRectangle(cornerRadius: size == .compact ? .cornerRadiusM : .cornerRadiusL))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    JoinChallengeCard(viewData: .previewValue())
        .padding()
}
