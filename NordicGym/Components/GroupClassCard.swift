//
//  GroupClassCard.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 03/09/2026.
//

import SwiftUI

// TODO: import tagged

struct GroupClassCardViewData {
    let id: String
    let className: String
    let date: String
    let location: String
    let duration: String
    let bookingState: BookingState
    let backgroundImage: Image

    static func previewValue(
        id: String = "1234",
        className: String = "Cycling Interval",
        date: String = "Tomorrow at 16:30",
        location: String = "Akersgata",
        duration: String = "45 min",
        bookingState: BookingState = .notBooked,
        backgroundImage: Image = Image(.cycling)
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

struct GroupClassCard: View {
    let viewData: GroupClassCardViewData

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(viewData.className)
                    .bold()
                    .font(.callout)
                Text(viewData.date)
                    .foregroundStyle(Color.accent)
                Text("\(viewData.location) - \(viewData.duration)")
            }
            .font(.callout)
            .foregroundStyle(.onAccent)

            Spacer()

            BookButton(bookingState: viewData.bookingState, size: .small)
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
            viewData
                .backgroundImage
                .resizable()
                .scaledToFill()
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: .cornerRadiusM))
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
                backgroundImage: Image(.rowing)
            )
        )

    }
    .padding()
}
