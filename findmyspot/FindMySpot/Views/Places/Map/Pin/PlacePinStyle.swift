//
//  PlacePinStyle.swift
//  FindMySpot
//
//  Created by josiaschweizer on 03.10.2026.
//

import SwiftUI

enum PlacePinStyle {
    case standard
    case favorite
    case bookmark
    case both

    init(isFavorite: Bool, isBookmark: Bool) {
        switch (isFavorite, isBookmark) {
        case (true, true): self = .both
        case (true, false): self = .favorite
        case (false, true): self = .bookmark
        case (false, false): self = .standard
        }
    }

    var color: Color {
        switch self {
        case .standard: AppColors.pin
        case .favorite, .both: AppColors.pinFavorite
        case .bookmark: AppColors.pinBookmark
        }
    }

    var iconColor: Color {
        switch self {
        case .bookmark: AppColors.pinBookmarkIcon
        default: AppColors.pinIcon
        }
    }

    var icon: String {
        switch self {
        case .standard: AppIcons.pin
        case .favorite, .both: AppIcons.favoriteSelected
        case .bookmark: AppIcons.bookmarkSelected
        }
    }

    var accessibilityText: String {
        switch self {
        case .standard: "Place"
        case .bookmark: "Bookmarked place"
        case .favorite: "Favorite place"
        case .both: "Favorite and bookmarked place"
        }
    }
}
