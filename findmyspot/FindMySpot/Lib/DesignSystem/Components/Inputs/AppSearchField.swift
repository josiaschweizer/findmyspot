//
//  AppSearchField.swift
//  FindMySpot
//
//  Created by josiaschweizer on 22.09.2026.
//

import SwiftUI

struct AppSearchField: View {
    let placeholder: String
    @Binding var text: String

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: AppIcons.search)
                .foregroundStyle(AppColors.textSecondary)

            TextField(placeholder, text: $text)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textPrimary)
                .focused($isFocused)

            if !text.isEmpty {
                Button {
                    text = StringUtil.EMPTY
                } label: {
                    Image(systemName: AppIcons.close)
                        .foregroundStyle(AppColors.textSecondary)
                }
                .buttonStyle(.plain)
            }
        }
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
                isFocused ? AppColors.focus : AppColors.borderDefault,
                lineWidth: isFocused ? 2 : 1
            )
        }
    }
}
