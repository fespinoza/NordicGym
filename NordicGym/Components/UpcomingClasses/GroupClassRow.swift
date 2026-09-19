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
        NavigationLink(destination: { GroupClassScreen(id: viewData.id) }) {
            GroupClassRowContent(viewData: viewData)
                .padding(.vertical, .spacingS)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

private struct GroupClassRowContent: View {
    let viewData: GroupClassRowViewData

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: .spacingM) {
                GroupClassTime(time: viewData.time, duration: viewData.duration)
                GroupClassSummary(
                    className: viewData.className,
                    instructorName: viewData.instructorName,
                    location: viewData.location
                )
                Spacer(minLength: .spacingXS)
                BookingStatusBadge(viewData: viewData.bookingState)
            }

            VStack(alignment: .leading, spacing: .spacingS) {
                HStack(alignment: .top, spacing: .spacingM) {
                    GroupClassTime(time: viewData.time, duration: viewData.duration)
                    GroupClassSummary(
                        className: viewData.className,
                        instructorName: viewData.instructorName,
                        location: viewData.location
                    )
                }

                BookingStatusBadge(viewData: viewData.bookingState)
            }
        }
    }
}

private struct GroupClassTime: View {
    let time: String
    let duration: String

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingXXS) {
            Text(time)
                .font(.headline)
            Text(duration)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

private struct GroupClassSummary: View {
    let className: String
    let instructorName: String
    let location: String

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingXXS) {
            Text(className)
                .font(.headline)
            Text("With \(instructorName)")
            Text(location)
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct BookingStatusBadge: View {
    let viewData: GroupClassRowViewData.BookingStateViewData

    var body: some View {
        Label(viewData.message, systemImage: viewData.imageName)
            .font(.caption.weight(.semibold))
            .foregroundStyle(viewData.foregroundColor)
            .padding(.horizontal, .spacingS)
            .padding(.vertical, .spacingXS)
            .background(viewData.foregroundColor.opacity(0.12), in: Capsule())
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    NavigationStack {
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
}
