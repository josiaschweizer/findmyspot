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

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .plain:
            Color.clear
        case .filled:
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(AppColors.surfaceSecondary)
        case .circle:
            Circle().fill(AppColors.elevatedBackground)
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foregroundColor)
            .background(background)
            .appPressedEffect(configuration.isPressed)
    }
}
