//
//  AppChoice.swift
//  findmyspot
//
//  Created by Josia Schweizer on 20.09.2026.
//

import SwiftUI

struct AppChoice: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    private var backgroundColor: Color {
        isSelected ? AppColors.selectedBackground : AppColors.surfaceWhite
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: AppIcons.checkmark)
                    .font(.system(size: 12, weight: .semibold))
                    .opacity(isSelected ? 1 : 0)

                Text(title)
                    .font(AppTypography.label)
                    .lineLimit(1)
            }
            .foregroundStyle(AppColors.textPrimary)
            .padding(.horizontal, AppSpacing.md)
            .frame(minHeight: AppLayout.minimumControlHeight)
            .background(backgroundColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppRadius.sm
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: AppRadius.sm
                )
                .stroke(AppColors.borderDefault)
            }
        }
        .buttonStyle(.plain)
    }
}
