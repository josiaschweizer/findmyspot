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

    var body: some View {
        AppFieldContainer(
            title: title,
            state: state,
            errorMessage: errorMessage,
            isFocused: isFocused
        ) {
            TextField(
                placeholder,
                text: $text
            )
            .font(AppTypography.body)
            .foregroundStyle(AppColors.textPrimary)
            .focused($isFocused)
        }
    }
}
