//
//  SettingView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import SwiftUI

struct SettingView: View {
    @Environment(AuthViewModel.self) private var auth

    var body: some View {
        Text("Settings")
            .navigationTitle("Settings")

        Button("Log Out", role: .destructive) {
            Task {
                await auth.signOut()
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
    }
}

#Preview {
    SettingView()
}
