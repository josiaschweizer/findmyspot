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
    let showViewSettingMenu: Bool
    let canSortByDistance: Bool

    @Binding var listLayout: PlaceListLayout

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

            if showViewSettingMenu {
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

                    Divider()

                    Picker("View", selection: $listLayout) {
                        ForEach(PlaceListLayout.allCases) { layout in
                            Text(layout.title)
                                .tag(layout)
                        }
                    }
                } label: {
                    Image(systemName: AppIcons.viewSettings)
                        .font(AppTypography.label)
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(
                            AppColors.elevatedBackground,
                            in: Circle()
                        )
                        .contentShape(Circle())
                }
                .menuStyle(.borderlessButton)
                .accessibilityLabel("View Settings")
                .accessibilityValue(
                    sortOrder.title + StringUtil.SPACE + listLayout.title
                )
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.lg)
    }

}
