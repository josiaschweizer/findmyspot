//
//  AuthPrimaryButton.swift
//  findmyspot
//
//  Created by Josia Schweizer on 13.09.2026.
//

import SwiftUI

struct AuthPrimaryButton: View {
    let title: String
    let isLoading: Bool
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()

                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(title).fontWeight(.semibold)

                    Image(systemName: "arrow.right")
                }

                Spacer()
            }
            .frame(height: 50)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background {
            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .fill(LinearGradient(
                colors: [
                    AppColors.primary,
                    AppColors.primaryDark
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
        }
        .opacity(isEnabled ? 1 : 0.45)
        .disabled(!isEnabled)
    }
}

#Preview {
    @Previewable @State var notifier = UserNotifier()

    VStack(spacing: 16) {
        AuthPrimaryButton(
            title: "Sign In",
            isLoading: false,
            isEnabled: true
        ) {
            notifier.success("Success")
        }

        AuthPrimaryButton(
            title: "Loading",
            isLoading: true,
            isEnabled: true
        ) {}

        AuthPrimaryButton(
            title: "Disabled",
            isLoading: false,
            isEnabled: false
        ) {}

    }
    .padding()
    .toastOverlay()
    .environment(notifier)
}
