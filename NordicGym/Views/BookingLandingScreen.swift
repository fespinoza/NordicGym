//
//  BookingLandingScreen.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 24/08/2026.
//

import SwiftUI

struct BookingLandingScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ScrollView(.horizontal) {
                    HStack {
                        VStack {
                            Image(systemName: "figure.run")
                                .font(.title2)
                                .padding(12)
                                .background(Circle().foregroundStyle(Color.red))
                            Text("Group Class")
                                .font(.caption)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("My saved searches 💙")
                            .font(.headline)

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Dance")
                                Text("5 clubs")
                                    .font(.caption)
                            }
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("My saved searches 💙")
                            .font(.headline)

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Dance")
                                Text("5 clubs")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(Text("Booking"))
    }
}

#Preview {
    NavigationStack {
        BookingLandingScreen()
    }
}
