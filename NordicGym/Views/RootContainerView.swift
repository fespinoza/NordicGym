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
                Text("Hello World")
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
                Label("Scan", systemImage: "qrcode")
            }

            Tab {
                Text("Hello World")
            } label: {
                Label("Find Clubs", systemImage: "location.circle")
            }

            Tab {
                Text("Hello World")
            } label: {
                Label("Activity", systemImage: "calendar.day.timeline.leading")
            }
        }
    }
}

#Preview {
    RootContainerView()
}
