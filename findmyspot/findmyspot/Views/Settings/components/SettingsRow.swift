//
//  SettingsRow.swift
//  FindMySpot
//
//  Created by josiaschweizer on 17.10.2026.
//

import SwiftUI

struct SettingsRow<Trailing: View>: View {
    private let icon: String
    private let title: String
    private let isDestructive: Bool
    private let showsChevron: Bool
    private let trailing: Trailing

    init(
        icon: String,
        title: String,
        isDestructive: Bool = false,
        showsChevron: Bool = false,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.icon = icon
        self.title = title
        self.isDestructive = isDestructive
        self.showsChevron = showsChevron
        self.trailing = trailing()
    }

    private var foreground: Color {
        isDestructive ? AppColors.error : AppColors.textPrimary
    }

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(AppTypography.body)
                .imageScale(.large)
                .foregroundStyle(foreground)
                .frame(width: AppSpacing.xxl)
                .accessibilityHidden(true)

            Text(title)
                .font(AppTypography.body)
                .foregroundStyle(foreground)

            Spacer(minLength: AppSpacing.sm)

            trailing

            if showsChevron {
                Image(systemName: AppIcons.chevronRight)
                    .font(AppTypography.body)
                    .foregroundStyle(
                        isDestructive
                            ? AppColors.error : AppColors.textSecondary
                    )
                    .accessibilityHidden(true)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .frame(minHeight: AppLayout.settingsRowMinHeight)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

extension SettingsRow where Trailing == EmptyView {
    init(
        icon: String,
        title: String,
        isDestructive: Bool = false,
        showsChevron: Bool = false
    ) {
        self.init(
            icon: icon,
            title: title,
            isDestructive: isDestructive,
            showsChevron: showsChevron
        ) {
            EmptyView()
        }
    }
}

extension SettingsRow where Trailing == Text {
    init(
        icon: String,
        title: String,
        value: String,
        showsChevron: Bool = false
    ) {
        self.init(icon: icon, title: title, showsChevron: showsChevron) {
            Text(value)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.md) {
        SettingsRow(
            icon: AppIcons.displayName,
            title: "Display name",
            value: "Josia",
            showsChevron: true
        )

        AppDivider()

        SettingsRow(
            icon: AppIcons.signOut,
            title: "Sign out",
            showsChevron: true
        )

        AppDivider()

        SettingsRow(
            icon: AppIcons.website,
            title: "findmyspot.ch",
            isDestructive: true,
            showsChevron: true
        )
    }
    .background(AppColors.elevatedBackground)
    .padding(AppSpacing.xl2)
    .background(AppColors.background)
}
