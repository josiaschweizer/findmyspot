//
//  PlaceFilterBar.swift
//  FindMySpot
//
//  Created by josiaschweizer on 02.10.2026.
//

import SwiftUI

struct PlaceFilterBar: View {
    let isLoading: Bool

    @Binding var searchText: String
    var isSearchFieldFocused: FocusState<Bool>.Binding

    let onOpenFilters: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            AppCard {
                HStack(spacing: AppSpacing.lg) {
                    Image(systemName: AppIcons.search)
                        .foregroundStyle(AppColors.primary)

                    TextField(
                        "Place or Properties",
                        text: $searchText
                    )
                    .font(AppTypography.body)
                    .tint(AppColors.primary)
                    .submitLabel(.search)
                    .onSubmit {
                        isSearchFieldFocused.wrappedValue = false
                    }

                    ProgressView()
                        .tint(AppColors.primary)
                        .frame(width: 20, height: 20)
                        .opacity(isLoading ? 1 : 0)
                        .accessibilityHidden(!isLoading)
                        .accessibilityLabel("Loading places")
                }
            }
            .frame(maxWidth: .infinity)

            AppIconButton(
                icon: AppIcons.filter,
                isEnabled: true
            ) {
                isSearchFieldFocused.wrappedValue = false
                onOpenFilters()
            }
            .background(
                AppColors.elevatedBackground,
                in: Circle()
            )
            .accessibilityLabel("Open Filters")
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.lg)
    }

}
