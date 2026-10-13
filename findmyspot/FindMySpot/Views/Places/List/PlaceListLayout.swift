//
//  PlaceListLayout.swift
//  FindMySpot
//
//  Created by josiaschweizer on 11.10.2026.
//

enum PlaceListLayout: String, CaseIterable, Identifiable {
    case compact
    case large

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .compact:
            return "Compact"
        case .large:
            return "Large cards"
        }
    }
}
