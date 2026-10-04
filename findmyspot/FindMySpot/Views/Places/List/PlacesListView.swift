//
//  PlacesListView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//
import SwiftUI

struct PlacesListView: View {
    let places: [Place]
    let onSelect: (UUID) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(places) { place in
                    Button(
                        action: {
                            onSelect(place.id)
                        },
                        label: {
                            HStack(spacing: AppSpacing.lg) {
                                Image(systemName: AppIcons.places)
                                    .font(AppTypography.titleMedium)
                                    .foregroundStyle(AppColors.primary)
                                    .frame(
                                        width: AppLayout.compactThumbnailSize,
                                        height: AppLayout.compactThumbnailSize
                                    )

                                VStack(
                                    alignment: .leading,
                                    spacing: AppSpacing.xs
                                ) {
                                    Text(place.name)
                                        .font(AppTypography.titleSmall)
                                        .foregroundStyle(AppColors.textPrimary)

                                    if let address = place.address,
                                        !address.isEmpty
                                    {
                                        Text(address)
                                            .font(AppTypography.caption)
                                            .foregroundStyle(
                                                AppColors.textSecondary
                                            )
                                    }
                                }
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )

                                Image(systemName: AppIcons.chevronRight)
                                    .foregroundStyle(AppColors.textSecondary)

                            }
                        }

                    )
                    .buttonStyle(.plain)
                }
            }
            .padding(AppSpacing.lg)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(AppColors.background)
    }
}
