//
//  BookButton.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 03/09/2026.
//

import SwiftUI

extension BookingState {
    var nextOperationTitle: String {
        switch self {
        case .booked,
            .bookedOnWaitingList:
            return "Unbook"
        case .notBooked,
            .notBookedOnWaitingList:
            return "Book"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .booked,
                .bookedOnWaitingList:
            return .white
        case .notBooked,
                .notBookedOnWaitingList:
            return .accent
        }
    }

    var textColor: Color {
        switch self {
        case .booked,
                .bookedOnWaitingList:
            return .accent
        case .notBooked,
                .notBookedOnWaitingList:
            return .onAccent
        }
    }
}

struct BookButton {
    let bookingState: BookingState
    let size: Size
}

extension BookButton {
    enum Size {
        case small
        case large
    }
}

extension BookButton: View {
    var body: some View {
        Button(action: {}) {
            Text(bookingState.nextOperationTitle)
        }
        .foregroundStyle(bookingState.textColor)
        .buttonStyle(.borderedProminent)
        .tint(bookingState.backgroundColor)
//        .overlay { Capsule().foregroundStyle(Color.red) }
        .buttonBorderShape(.capsule)
    }
}

#Preview(traits: .sizeThatFitsLayout, arguments: BookingState.allCases) { state in
    BookButton(bookingState: state, size: .small)
        .padding()
}
