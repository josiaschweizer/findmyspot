//
//  SettingsSection.swift
//  FindMySpot
//
//  Created by josiaschweizer on 17.10.2026.
//

import SwiftUI

struct SettingsSection<Content: View>: View {
    private let title: String
    private let footer: String?
    private let content: Content

    init(
        _ title: String,
        footer: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.footer = footer
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(AppTypography.titleMedium)
                .foregroundStyle(AppColors.textPrimary)
                .accessibilityAddTraits(.isHeader)

            card

            if let footer {
                Text(footer)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    private var card: some View {
        VStack(spacing: 0) {
            Group(subviews: content) { subviews in
                ForEach(subviews) { subview in
                    subview

                    // add a divider to the end if the current subview isn't the last one
                    if subview.id != subviews.last?.id {
                        AppDivider()
                    }
                }
            }
        }
        .background(
            AppColors.elevatedBackground,
            in: RoundedRectangle(cornerRadius: AppRadius.xl)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xl)
                .strokeBorder(AppColors.borderDefault)
                .allowsHitTesting(false)
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: AppSpacing.xxl) {
            SettingsSection("Account") {
                SettingsRow(
                    icon: AppIcons.account,
                    title: "Email",
                    value: "josia@example.com"
                )

                SettingsRow(
                    icon: AppIcons.displayName,
                    title: "Display name",
                    value: "Josia",
                    showsChevron: true
                )
            }

            SettingsSection(
                "Location",
                footer: "Your location is only used to show places near you."
            ) {
                SettingsRow(icon: AppIcons.location, title: "Location access") {
                    Text("Allowed")
                        .font(AppTypography.bodyStrong)
                        .foregroundStyle(AppColors.success)
                }
            }
        }
        .padding(AppSpacing.xl2)
    }
    .background(AppColors.background)
}
