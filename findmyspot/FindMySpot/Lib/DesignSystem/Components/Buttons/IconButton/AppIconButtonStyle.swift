//
//  AppIconButtonStyle.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppIconButtonStyle: ButtonStyle {
    let variant: AppIconButtonVariant
    let isEnabled: Bool

    private var foregroundColor: Color {
        isEnabled ? AppColors.textPrimary : AppColors.textSecondary
    }

    private var backgroundColor: Color {
        switch variant {
        case .plain:
            .clear
        case .filled:
            AppColors.surfaceSecondary
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppRadius.md
                )
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
