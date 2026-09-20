//
//  AppButton.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppButton: View {
    let title: String
    let variant: AppButtonVariant
    let isEnabled: Bool
    let isLoading: Bool
    let action: () -> Void

    init(
        _ title: String,
        variant: AppButtonVariant = .primary,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                }

                Text(title)
            }
        }
        .buttonStyle(
            AppButtonStyle(
                variant: variant,
                isEnabled: isEnabled,
                isLoading: isLoading
            )
        )
        .disabled(!isEnabled || isLoading)
    }

}
