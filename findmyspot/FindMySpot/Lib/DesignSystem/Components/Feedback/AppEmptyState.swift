//
//  AppEmptyState.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppEmptyState: View {
    let icon: String?
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        icon: String? = nil,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(
            spacing: AppSpacing.md
        ) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
            }

            VStack(
                spacing: AppSpacing.sm
            ) {
                Text(title)
                    .font(AppTypography.titleSmall)
                    .foregroundStyle(AppColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle, let action {
                AppButton(
                    actionTitle,
                    variant: .secondary,
                    action: action
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.xxl)
    }
}

#Preview {
    AppEmptyState(
        icon: "heart",
        title: "Noch keine Favoriten",
        message: "Markiere einen Ort mit dem Herzen",
        actionTitle: "Zurücksetzen"
    ) {

    }
}
