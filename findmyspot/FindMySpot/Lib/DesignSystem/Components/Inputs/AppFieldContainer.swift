//
//  AppFieldContainer.swift
//  FindMySpot
//
//  Created by josiaschweizer on 22.09.2026.
//

import SwiftUI

struct AppFieldContainer<Content: View>: View {
    let title: String
    let state: AppTextFieldState
    let errorMessage: String?
    let isFocused: Bool

    @ViewBuilder let content: Content

    private var borderColor: Color {
        if state == .error {
            return AppColors.textDestructive
        }

        if isFocused {
            return AppColors.focus
        }

        return AppColors.borderDefault
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: AppSpacing.sm
        ) {
            Text(title)
                .font(AppTypography.label)
                .foregroundStyle(AppColors.textPrimary)

            content
                .padding(.horizontal, AppSpacing.lg)
                .frame(minHeight: AppLayout.controlHeight)
                .background(AppColors.surfaceWhite)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: AppRadius.lg
                    )
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: AppRadius.lg
                    )
                    .stroke(
                        borderColor,
                        lineWidth: isFocused ? 2 : 1
                    )
                }

            if let errorMessage, state == .error {
                Text(errorMessage)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textDestructive)
            }
        }
    }
}
