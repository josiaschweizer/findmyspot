//
//  AppTag.swift
//  FindMySpot
//
//  Created by josiaschweizer on 22.09.2026.
//

import SwiftUI

struct AppTag: View {
    let title: String
    let variant: AppTagVariant

    init(
        _ title: String,
        variant: AppTagVariant = .neutral
    ) {
        self.title = title
        self.variant = variant
    }

    var body: some View {
        Text(title)
            .font(AppTypography.label)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.xs)
            .background(backgroundColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppRadius.xs
                )
            )
    }

    private var foregroundColor: Color {
        switch variant {
        case .neutral, .highlighted:
            AppColors.textPrimary
        case .success:
            AppColors.success
        case .warning:
            AppColors.warning
        case .info:
            AppColors.info
        case .error:
            AppColors.error
        }
    }

    private var backgroundColor: Color {
        switch variant {
        case .neutral:
            AppColors.surfaceSecondary
        case .highlighted:
            AppColors.selectedBackground
        case .success:
            AppColors.successBackground
        case .warning:
            AppColors.warningBackground
        case .info:
            AppColors.infoBackground
        case .error:
            AppColors.errorBackground
        }
    }

}

#Preview {
    HStack(
        spacing: AppSpacing.sm
    ) {
        AppTag("Title", variant: .success)
    }
}
