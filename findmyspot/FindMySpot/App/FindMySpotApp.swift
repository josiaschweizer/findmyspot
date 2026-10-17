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

    @AppStorage(AppearancePreference.storageKey)
    private var appearacne = AppearancePreference.system

    var body: some Scene {
        WindowGroup {
            RootView()
                .toastOverlay()
                .environment(auth)
                .environment(notifier)
                .preferredColorScheme(appearacne.colorScheme)
        }
    }
}
