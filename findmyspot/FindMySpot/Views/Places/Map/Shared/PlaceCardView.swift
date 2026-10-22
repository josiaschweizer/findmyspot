//
//  PlaceCardView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 11.10.2026.
//

import SwiftUI

struct PlaceCardView: View {
    let place: Place

    var imageURL: URL? = nil
    var distanceText: String? = nil
    var featureNames: [String] = []

    var isFavoriteSaving = false
    var isBookmarkSaving = false

    var onSelect: (() -> Void)? = nil
    var onFavorite: (() -> Void)? = nil
    var onBookmark: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            selectableContent

            HStack(spacing: AppSpacing.sm) {
                Spacer()

                AppToggleIconButton(
                    icon: AppIcons.favorite,
                    selectedIcon: AppIcons.favoriteSelected,
                    isSelected: place.isFavorite,
                    isEnabled: onFavorite != nil && !isFavoriteSaving,
                    action: { onFavorite?() }
                )
                .accessibilityLabel(
                    place.isFavorite
                        ? "Remove favorite"
                        : "Add favorite"
                )

                AppToggleIconButton(
                    icon: AppIcons.bookmark,
                    selectedIcon: AppIcons.bookmarkSelected,
                    isSelected: place.isBookmark,
                    isEnabled: onBookmark != nil && !isBookmarkSaving,
                    action: { onBookmark?() }
                )
                .accessibilityLabel(
                    place.isBookmark
                        ? "Remove bookmark"
                        : "Add bookmark"
                )
            }
        }
        .padding(AppSpacing.lg)
        .background(
            AppColors.elevatedBackground,
            in: RoundedRectangle(cornerRadius: AppRadius.huge)
        )
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.huge)
                .strokeBorder(AppColors.borderDefault)
                .allowsHitTesting(false)
        }
    }

    @ViewBuilder
    private var selectableContent: some View {
        if let onSelect {
            Button(action: onSelect) {
                content.contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        } else {
            content
        }
    }

    private var content: some View {
        HStack(alignment: .top, spacing: AppSpacing.lg) {
            PlaceThumbnail(imageURL: imageURL)

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(place.name)
                    .font(AppTypography.titleMedium)
                    .foregroundStyle(AppColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                if let distanceText, !distanceText.isEmpty {
                    Text(distanceText)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                }

                if !featureNames.isEmpty {
                    Text(
                        featureNames
                            .prefix(3)
                            .joined(separator: StringUtil.SPACE_STRITCH_SPACE)
                    )
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
