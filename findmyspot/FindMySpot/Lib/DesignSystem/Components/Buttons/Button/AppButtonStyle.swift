//
//  AppButtonStyle.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppButtonStyle: ButtonStyle {
    let variant: AppButtonVariant
    let isEnabled: Bool
    let isLoading: Bool

    private var foregroundColor: Color {
        switch variant {
        case .primary:
            return AppColors.surfaceWhite
        case .secondary:
            return AppColors.textPrimary
        case .destructive:
            return AppColors.surfaceWhite
        }
    }

    private var backgroundColor: Color {
        guard isEnabled else {
            return AppColors.borderDefault
        }

        switch variant {
        case .primary:
            return AppColors.primaryAction
        case .secondary:
            return AppColors.surfaceSecondary
        case .destructive:
            return AppColors.textDestructive
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.bodyStrong)
            .frame(maxWidth: .infinity)
            .frame(height: AppLayout.controlHeight)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppRadius.md
                )
            )
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}
