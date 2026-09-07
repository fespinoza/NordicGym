//
//  GroupClassRow.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 04/09/2026.
//

import SwiftUI
// import Tagged

struct GroupClassRowViewData {
    let id: String
    let className: String
    let instructorName: String
    let location: String
    let time: String
    let duration: String
    let bookingState: BookingStateViewData

    enum BookingState {
        case booked(message: String)
        case bookedOnWaitingList(message: String)
    }

    struct BookingStateViewData {
        let message: String
        let imageName: String
        let foregroundColor: Color
    }
}

extension GroupClassRowViewData {
    static func previewValue(
        id: String = "",
        className: String = "Love2Dance",
        instructorName: String = "Eva",
        location: String = "Ringnes Park",
        time: String = "17:30",
        duration: String = "60 min",
        bookingState: BookingStateViewData = .previewValue()
    ) -> Self {
        .init(
            id: id,
            className: className,
            instructorName: instructorName,
            location: location,
            time: time,
            duration: duration,
            bookingState: bookingState
        )
    }
}

extension GroupClassRowViewData.BookingStateViewData {
    static func previewValue(
        message: String = "3 spots available",
        imageName: String = "checkmark",
        foregroundColor: Color = Color.success
    ) -> Self {
        .init(
            message: message,
            imageName: imageName,
            foregroundColor: foregroundColor
        )
    }
}

struct GroupClassRow: View {
    let viewData: GroupClassRowViewData

    var body: some View {
        HStack(spacing: .spacingM) {
            RoundedRectangle(cornerRadius: .cornerRadiusS)
                .frame(width: 4)
                .foregroundStyle(.accent)

            HStack(alignment: .top, spacing: .spacingM) {
                VStack(alignment: .leading) {
                    Text(viewData.time)
                    Text(viewData.duration)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading) {
                    Text(viewData.className)
                    Text("w/ \(viewData.instructorName)")
                        .foregroundStyle(.secondary)
                    Text(viewData.location)
                        .foregroundStyle(.secondary)
                    Text(viewData.bookingState.message)
                        .foregroundStyle(viewData.bookingState.foregroundColor)
                }
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Image(systemName: viewData.bookingState.imageName)
                .bold()
                .padding(.spacingXS)
                .foregroundStyle(.onAccent)
                .background {
                    Circle()
                        .foregroundStyle(viewData.bookingState.foregroundColor)
                }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        GroupClassRow(viewData: .previewValue())
            .frame(maxHeight: 120)

        GroupClassRow(
            viewData: .previewValue(
                bookingState: .previewValue(
                    message: "Number 7 people on the waiting list",
                    imageName: "clock",
                    foregroundColor: .waitingList
                )
            )
        )
            .frame(maxHeight: 120)
    }
    .padding()
}
