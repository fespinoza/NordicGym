//
//  ContentCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 04/09/2026.
//

import SwiftUI

struct ContentCardViewData: Equatable, Identifiable {
    let id: String
    let title: String
    let text: String
    let image: ImageViewData?
}

extension ContentCardViewData {
    init(dto: FeaturedContent) {
        self.init(
            id: dto.id.uuidString,
            title: dto.title,
            text: dto.message,
            image: .remote(from: dto.imageURL)
        )
    }

    static func previewValue(
        id: String = "preview-content-card",
        title: String = "What are your objectives?",
        text: String = """
        It is a long established fact that a reader will be distracted by the readable content of a page when \
        looking at its layout.
        """,
        image: ImageViewData? = .image(Image(.groupClass))
    ) -> Self {
        .init(
            id: id,
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

struct HomeContentCard: View {
    let viewData: ContentCardViewData

    var body: some View {
        if let image = viewData.image {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 0) {
                    ContentCardCopy(title: viewData.title, text: viewData.text)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Color.clear
                        .frame(width: 220)
                        .frame(minHeight: 180)
                        .overlay {
                            ContentCardImage(image: image)
                        }
                        .clipped()
                }
                .frame(minWidth: 600)

                VStack(alignment: .leading, spacing: 0) {
                    Color.clear
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .overlay {
                            ContentCardImage(image: image)
                        }
                        .clipped()

                    ContentCardCopy(title: viewData.title, text: viewData.text)
                        .padding(.top, .spacingM)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            .homeCardStyle(contentPadding: 0)
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadiusL))
        } else {
            ContentCardCopy(title: viewData.title, text: viewData.text)
                .homeCardStyle(contentPadding: 0)
        }
    }
}

private struct ContentCardCopy: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingS) {
            Text(title)
                .font(.headline)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.spacingM)
        .fixedSize(horizontal: false, vertical: true)
    }
}

private struct ContentCardImage: View {
    let image: ImageViewData

    var body: some View {
        CustomAsyncImage(state: image) { resolvedImage in
            resolvedImage
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.secondary.opacity(0.12)
        }
        .clipped()
        .accessibilityHidden(true)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        ContentCard(viewData: .previewValue())
        ContentCard(viewData: .previewValue(image: nil))
    }
    .padding()
}
