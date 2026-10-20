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
    var onOpenDetail: () -> Void

    private var displayedPlace: Place {
        var result = place
        result.isFavorite = isFavorite
        result.isBookmark = isBookmark
        return result
    }

    private var favoriteAction: (() -> Void)? {
        guard let onFavorite else {
            return nil
        }

        return {
            onFavorite(place.id, userNotifier)
        }
    }

    private var bookmarkAction: (() -> Void)? {
        guard let onBookmark else {
            return nil
        }

        return {
            onBookmark(place.id, userNotifier)
        }
    }

    var body: some View {
        PlaceCardView(
            place: displayedPlace,
            imageURL: imageURL,
            distanceText: distanceText,
            featureNames: featureNames,
            isFavoriteSaving: isFavoriteSaving,
            isBookmarkSaving: isBookmarkSaving,
            onSelect: onOpenDetail,
            onFavorite: favoriteAction,
            onBookmark: bookmarkAction
        )
        .overlay(alignment: .topTrailing) {
            closeButton
                .padding(.trailing, AppSpacing.sm)
                .offset(y: -AppLayout.minimumControlHeight / 2)
        }
        .padding(.top, AppLayout.minimumControlHeight / 2)
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
