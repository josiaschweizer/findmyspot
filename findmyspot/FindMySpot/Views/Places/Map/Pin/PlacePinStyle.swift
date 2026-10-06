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

    init(isFavorite: Bool, isBookmark: Bool) {
        if isFavorite {
            self = .favorite
        } else if isBookmark {
            self = .bookmark
        } else {
            self = .standard
        }
    }

    var color: Color {
        switch self {
        case .standard: AppColors.pin
        case .favorite: AppColors.pinFavorite
        case .bookmark: AppColors.pinBookmark
        }
    }

    var iconColor: Color {
        AppColors.pinIcon
    }

    enum PinIcon {
        case asset(String)
        case system(String)
    }

    var icon: PinIcon {
        switch self {
        case .standard: .asset(AppIcons.locationDto)
        case .favorite: .system(AppIcons.favoriteSelected)
        case .bookmark: .system(AppIcons.bookmarkSelected)
        }
    }
    
    var iconScale: CGFloat {
        switch self {
        case .standard: 0.5
        case .favorite: 0.45
        case .bookmark: 0.5
        }
    }

    var accessibilityText: String {
        switch self {
        case .standard: "Place"
        case .bookmark: "Bookmarked place"
        case .favorite: "Favorite place"
        }
    }
}
