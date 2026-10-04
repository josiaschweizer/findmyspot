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
            if isLoading {
                loadingCard
            } else {
                AppCard {
                    HStack(spacing: AppSpacing.lg) {
                        Image(systemName: AppIcons.search)
                            .foregroundStyle(AppColors.primary)

                        TextField(
                            "Place or Properties...",
                            text: $searchText
                        )
                        .font(AppTypography.body)
                        .tint(AppColors.primary)
                        .submitLabel(.search)
                        .focused(isSearchFieldFocused)
                        .onSubmit {
                            isSearchFieldFocused.wrappedValue = false
                        }
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
                .background(AppColors.elevatedBackground, in: Circle())
                .accessibilityLabel("Open Filters")
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.lg)
    }

    private var loadingCard: some View {
        AppCard {
            HStack(spacing: AppSpacing.lg) {
                ProgressView()
                    .tint(AppColors.primary)

                Text("Loading places...")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textPrimary)
            }
        }
    }
}
