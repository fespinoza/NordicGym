//
//  RootContainerView.swift
//  NordicGym
//
//  Created by Felipe Espinoza on 24/08/2026.
//

import SwiftUI

struct RootContainerView: View {
    var body: some View {
        TabView {
            Tab {
                NavigationStack {
                    HomeScreen(modules: [
                        .upcomingWorkouts([.previewValue()]),
                        .friendActivity([.previewValue(), .previewValue(), .previewValue()]),
                        .joinYourFriends([.previewValue(), .previewValue(), .previewValue(), .previewValue()]),
                        .contentCard(.previewValue())
                    ])
                }
            } label: {
                Label("Home", systemImage: "house")
            }

            Tab {
                Text("Hello World")
            } label: {
                Label("Book", systemImage: "clock")
            }

            Tab {
                Text("Hello World")
            } label: {
                Label("Check in", systemImage: "qrcode")
            }

            Tab {
                Text("Hello World")
            } label: {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

#Preview {
    RootContainerView()
        .tint(Color.indigo)
}
