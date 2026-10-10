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

    @Binding var sortOrder: PlaceSortOrder
    let showsSortButton: Bool
    let canSortByDistance: Bool

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
                    .focused(isSearchFieldFocused)
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

            if showsSortButton {
                Menu {
                    Picker("Sort by", selection: $sortOrder) {
                        ForEach(PlaceSortOrder.allCases) { option in
                            Text(option.title)
                                .tag(option)
                                .disabled(
                                    option == .nearest && !canSortByDistance
                                )
                        }
                    }
                } label: {
                    Image(systemName: AppIcons.arrowUpArrowDown)
                        .font(AppTypography.label)
                        .foregroundStyle(AppColors.primary)
                        .frame(width: 44, height: 44)
                        .background(
                            AppColors.elevatedBackground,
                            in: Circle()
                        )
                        .contentShape(Circle())
                }
                .menuStyle(.borderlessButton)
                .accessibilityLabel("Sort places")
                .accessibilityValue(sortOrder.title)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.lg)
    }

}
