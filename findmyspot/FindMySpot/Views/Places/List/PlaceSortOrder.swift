//
//  PlaceSortOrder.swift
//  FindMySpot
//
//  Created by josiaschweizer on 10.10.2026.
//

enum PlaceSortOrder: String, CaseIterable, Identifiable {
    case nameAscending
    case nameDescending
    case nearest
    case favoritesFirst

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .nameAscending:
            return "Name A-Z"
        case .nameDescending:
            return "Name Z-A"
        case .nearest:
            return "Nearest first"
        case .favoritesFirst:
            return "Favorites first"
        }
    }
}
