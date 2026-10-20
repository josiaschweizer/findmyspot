//
//  AddPlaceSectionTitle.swift
//  FindMySpot
//

import SwiftUI

struct AddPlaceSectionTitle: View {
    let eyebrow: String
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(eyebrow)
                .font(AppTypography.caption)
                .tracking(0.4)
                .foregroundStyle(AppColors.textSecondary)

            Text(title)
                .font(AppTypography.titleLarge)

            if let subtitle {
                Text(subtitle)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }
}
