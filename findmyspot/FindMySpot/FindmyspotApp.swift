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
    @State private var notifier = UserNotifier()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(auth)
                .environment(notifier)
                .toastOverlay()
        }
    }
}
