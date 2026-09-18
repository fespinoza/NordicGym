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
                    HomeScreen()
                }
            } label: {
                Label("Home", systemImage: "house")
            }

            Tab {
                NavigationStack {
                    BookScreen()
                }
            } label: {
                Label("Book", systemImage: "clock")
            }

            Tab {
                Text("WIP")
            } label: {
                Label("Check in", systemImage: "qrcode")
            }

            Tab {
                Text("WIP")
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
