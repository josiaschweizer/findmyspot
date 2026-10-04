//
//  PlacePreviewView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 01.10.2026.
//
import SwiftUI

struct PlacePreviewView: View {
    @Environment(UserNotifier.self) private var userNotifier

    let place: Place

    var imageURL: URL? = nil
    var distanceText: String? = nil
    var featureNames: [String] = []

    var isFavorite = false
    var isFavoriteSaving = false
    var onFavorite: ((UUID, UserNotifier) -> Void)? = nil
    var isBookmark = false
    var isBookmarkSaving = false
    var onBookmark: ((UUID, UserNotifier) -> Void)? = nil

    var onClose: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            HStack(
                alignment: .top,
                spacing: AppSpacing.lg
            ) {
                thumbail

                VStack(
                    alignment: .leading,
                    spacing: AppSpacing.sm
                ) {
                    Text(place.name)
                        .font(AppTypography.titleMedium)
                        .foregroundStyle(AppColors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    if let distanceText {
                        Text(distanceText)
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }

                    if !featureNames.isEmpty {
                        Text(
                            featureNames.prefix(3).joined(
                                separator: StringUtil.SPACE_STRITCH_SPACE
                            )
                        )
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.trailing, AppSpacing.lg)

            HStack(spacing: AppSpacing.sm) {
                Spacer()

                AppToggleIconButton(
                    icon: AppIcons.favorite,
                    selectedIcon: AppIcons.favoriteSelected,
                    isSelected: isFavorite,
                    isEnabled: onFavorite != nil && !isFavoriteSaving,
                    action: {
                        onFavorite?(place.id, userNotifier)
                    }
                )
                .accessibilityLabel(
                    isFavorite ? "Remove favorite" : "Add favorite"
                )

                AppToggleIconButton(
                    icon: AppIcons.bookmark,
                    selectedIcon: AppIcons.bookmarkSelected,
                    isSelected: isBookmark,
                    isEnabled: onBookmark != nil && !isBookmarkSaving,
                    action: {
                        onBookmark?(place.id, userNotifier)
                    }
                )
                .accessibilityLabel(
                    isBookmark ? "Remove bookmark" : "Add bookmark"
                )
            }
            .id(place.id)
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
        .overlay(alignment: .topTrailing) {
            closeButton
                .padding(.trailing, AppSpacing.sm)
                .offset(y: -AppLayout.minimumControlHeight / 2)
        }
        .padding(.top, AppLayout.minimumControlHeight / 2)
    }

    private var thumbail: some View {
        Group {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .empty, .failure:
                        imagePlaceholder

                    @unknown default:
                        imagePlaceholder
                    }
                }
            } else {
                imagePlaceholder
            }
        }
        .frame(
            width: AppLayout.thumbnailSize,
            height: AppLayout.thumbnailSize
        )
        .clipShape(
            RoundedRectangle(cornerRadius: AppRadius.lg)
        )
        .accessibilityHidden(true)
    }

    private var imagePlaceholder: some View {
        ZStack {
            AppColors.surfaceSecondary

            Image(systemName: AppIcons.places)
                .font(AppTypography.titleLarge)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private var closeButton: some View {
        AppIconButton(
            icon: AppIcons.close,
            isEnabled: true,
            action: onClose
        )
        .background(AppColors.elevatedBackground, in: Circle())
        .overlay {
            Circle()
                .strokeBorder(AppColors.borderDefault)
                .allowsHitTesting(false)
        }
        .accessibilityLabel("Close preview")
    }
}
