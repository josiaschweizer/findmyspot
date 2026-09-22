//
//  ContentView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 05.09.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "house") {
                NavigationStack {
                    DashboardView()
                }
            }
            Tab("Places", systemImage: "mappin.and.ellipse") {
                NavigationStack {
                    PlacesView()
                }
            }
            Tab("Settings", systemImage: "gearshape.fill") {
                NavigationStack {
                    SettingView()
                }
            }
            Tab("Design System", systemImage: "hammer") {
                NavigationStack {
                    DesignSystemPreview()
                }
            }

        }
    }

}

#Preview {
    ContentView()
}
