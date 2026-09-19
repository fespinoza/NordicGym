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
    let image: ImageViewData?
}

extension ContentCardViewData {
    init(dto: FeaturedContent) {
        self.init(
            title: dto.title,
            text: dto.title,
            image: .remote(from: dto.imageURL)
        )
    }

    static func previewValue(
        title: String = "What are your objectives?",
        text: String = """
        It is a long established fact that a reader will be distracted by the readable content of a page when \
        looking at its layout.
        """,
        image: ImageViewData? = .image(Image(.groupClass))
    ) -> Self {
        .init(
            title: title,
            text: text,
            image: image
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
            .font(.subheadline)
            .padding(.vertical, .spacingS)
            .padding(.leading, .spacingS)
            .padding(.trailing, viewData.image == nil ? .spacingS : 0)

            if viewData.image != nil {
                Color.clear
                    .frame(width: imageSize, height: 50)
            }
        }
        .background(alignment: .trailing) {
            CustomAsyncImage(state: viewData.image) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                EmptyView()
            }
            .frame(width: imageSize)
            .clipped()
        }
        .background { Color(uiColor: .secondarySystemBackground) }
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadiusM))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        ContentCard(viewData: .previewValue())
        ContentCard(viewData: .previewValue(image: nil))
    }
    .padding()
}
