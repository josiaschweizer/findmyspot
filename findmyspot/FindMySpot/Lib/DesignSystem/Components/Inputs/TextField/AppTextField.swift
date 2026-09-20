//
//  AppTextField.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var state: AppTextFieldState = .normal
    var errorMessage: String?

    @FocusState private var isFocused: Bool

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

            TextField(
                placeholder,
                text: $text
            )
            .font(AppTypography.body)
            .foregroundStyle(AppColors.textPrimary)
            .focused($isFocused)
            .padding(.horizontal, AppSpacing.lg)
            .frame(height: AppLayout.controlHeight)
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
