//
//  ContentCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 04/09/2026.
//

import SwiftUI

struct ContentCardViewData: Equatable {
    let title: String
    let text: String
    let imageURL: URL?
}

extension ContentCardViewData {
    init(dto: FeaturedContent) {
        self.init(
            title: dto.title,
            text: dto.title,
            imageURL: dto.imageURL
        )
    }

    static func previewValue(
        title: String = "What are your objectives?",
        text: String = """
        It is a long established fact that a reader will be distracted by the readable content of a page when \
        looking at its layout.
        """,
        imageURL: URL? = nil
    ) -> Self {
        .init(
            title: title,
            text: text,
            imageURL: imageURL
        )
    }
}

struct ContentCard: View {
    let viewData: ContentCardViewData

    private let imageSize: CGFloat = 150

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .spacingS) {
                Text(viewData.title)
                    .bold()
                Text(viewData.text)
            }
            .font(.callout)
            .padding(.vertical, .spacingS)
            .padding(.leading, .spacingS)
            .padding(.trailing, viewData.imageURL == nil ? .spacingS : 0)

            if viewData.imageURL != nil {
                Color.clear
                    .frame(width: imageSize, height: 50)
            }
        }
        .background(alignment: .trailing) {
            AsyncImage(url: viewData.imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize)
                    .clipped()
            } placeholder: {
                EmptyView()
            }
        }
        .background { Color.cardBackground }
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadiusM))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        ContentCard(viewData: .previewValue())
        ContentCard(viewData: .previewValue(imageURL: nil))
    }
    .padding()
}
