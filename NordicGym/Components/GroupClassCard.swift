//
//  GroupClassCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 03/09/2026.
//

import SwiftUI
import Tagged

struct GroupClassCardViewData: Identifiable, Equatable {
    let id: GroupClassID
    let className: String
    let date: String
    let location: String
    let duration: String
    let bookingState: BookingState
    let backgroundImage: ImageViewData?

    static func previewValue(
        id: GroupClassID = .previewValue(),
        className: String = "Cycling Interval",
        date: String = "Tomorrow at 16:30",
        location: String = "Akersgata",
        duration: String = "45 min",
        bookingState: BookingState = .notBooked,
        backgroundImage: ImageViewData? = nil
    ) -> Self {
        .init(
            id: id,
            className: className,
            date: date,
            location: location,
            duration: duration,
            bookingState: bookingState,
            backgroundImage: backgroundImage
        )
    }
}

extension GroupClassCardViewData {
    init(dto: UpcomingGroupClass) {
        self.init(
            id: dto.id,
            className: dto.name,
            date: dto.dateTime.formatted(.relative(presentation: .named, unitsStyle: .wide)),
            location: dto.location,
            duration: dto.durationInMinutes.formatted() + " min",
            bookingState: dto.bookingState,
            backgroundImage: .remote(from: dto.imageURL)
        )
    }
}

struct GroupClassCard: View {
    let viewData: GroupClassCardViewData
    var onBook: () -> Void = {}

    var body: some View {
        NavigationLink(destination: { GroupClassScreen(id: viewData.id) }) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(viewData.className)
                        .bold()
                    Text(viewData.date)
                        .foregroundStyle(Color.accent)
                    Text("\(viewData.location) - \(viewData.duration)")
                }
                .font(.subheadline)
                .foregroundStyle(.onAccent)

                Spacer()

                BookButton(bookingState: viewData.bookingState, size: .small, action: onBook)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.spacingS)
            .frame(width: 200, height: 250)
            .background(alignment: .top) {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .black.opacity(0), location: 0.00),
                        Gradient.Stop(color: .black, location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 1),
                    endPoint: UnitPoint(x: 0.5, y: 0)
                )
                .frame(height: 90)
            }
            .background(alignment: .bottom) {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .black.opacity(0), location: 0.00),
                        Gradient.Stop(color: .black.opacity(0.6), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .frame(height: 48)
            }
            .background {
                if let backgroundImage = viewData.backgroundImage {
                    CustomAsyncImage(state: backgroundImage) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    }
                }
            }
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadiusM))
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        GroupClassCard(viewData: .previewValue())

        GroupClassCard(
            viewData: .previewValue(
                className: "Viking Rowing",
                date: "Wednesday at 06:00",
                location: "Fjord",
                duration: "60 min",
                bookingState: .bookedOnWaitingList,
                backgroundImage: nil
            )
        )

    }
    .padding()
}
