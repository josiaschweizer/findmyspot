//
//  AppTextArea.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppTextArea: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var state: AppTextFieldState = .normal
    var errorMessage: String?

    @FocusState private var isFocused: Bool

    var body: some View {
        AppFieldContainer(
            title: title,
            state: state,
            errorMessage: errorMessage,
            isFocused: isFocused
        ) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                        .padding(.top, AppSpacing.sm)
                }

                TextEditor(text: $text)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textPrimary)
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: AppLayout.textAreaMinHeight)
                    .padding(.horizontal, -AppSpacing.xs)
            }
        }
    }
}
