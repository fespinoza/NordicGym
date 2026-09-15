//
//  GroupClassRow.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 04/09/2026.
//

import SwiftUI
import Tagged

struct GroupClassRowViewData: Identifiable, Equatable {
    let id: GroupClassID
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

    struct BookingStateViewData: Equatable {
        let message: String
        let imageName: String
        let foregroundColor: Color
    }
}

extension GroupClassRowViewData {
    init(dto: UpcomingGroupClass) {
        let bookingState: BookingStateViewData
        switch dto.bookingState {
        case .booked:
            bookingState = .init(message: "Booked", imageName: "checkmark", foregroundColor: .success)
        case .bookedOnWaitingList:
            bookingState = .init(message: "On the waiting list", imageName: "clock", foregroundColor: .waitingList)
        case .notBooked:
            bookingState = .init(
                message: dto.availableSpots.formatted() + " spots available",
                imageName: "plus",
                foregroundColor: .accent
            )
        case .notBookedOnWaitingList:
            bookingState = .init(message: "Join the waiting list", imageName: "clock", foregroundColor: .waitingList)
        }

        self.init(
            id: dto.id,
            className: dto.name,
            instructorName: dto.instructorName,
            location: dto.location,
            time: dto.dateTime.formatted(date: .omitted, time: .shortened),
            duration: dto.durationInMinutes.formatted() + " min",
            bookingState: bookingState
        )
    }

    static func previewValue(
        id: GroupClassID = .previewValue(),
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
            Spacer(minLength: 4)

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
        .padding(.vertical, .spacingXS)
        .background(alignment: .leading) {
            RoundedRectangle(cornerRadius: .cornerRadiusS)
                .frame(width: 4)
                .foregroundStyle(.accent)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        GroupClassRow(viewData: .previewValue())
//            .frame(maxHeight: 120)

        GroupClassRow(
            viewData: .previewValue(
                bookingState: .previewValue(
                    message: "Number 7 people on the waiting list",
                    imageName: "clock",
                    foregroundColor: .waitingList
                )
            )
        )
//            .frame(maxHeight: 120)
    }
    .padding()
}
