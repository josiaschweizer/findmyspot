//
//  FindMySpotApp.swift
//  FindMySpot
//
//  Created by josiaschweizer on 05.09.2026.
//

import SwiftUI

@main
struct FindMySpotApp: App {
    @State private var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(auth)
        }
    }
}
