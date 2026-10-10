//
//  PlaceFilter.swift
//  FindMySpot
//
//  Created by josiaschweizer on 02.10.2026.
//

import Foundation

struct PlaceFilter: Equatable {
    private(set) var purposeIDs: Set<UUID> = []
    private(set) var featureIDs: Set<UUID> = []
    private(set) var searchText: String = StringUtil.EMPTY

    var isEmpty: Bool {
        return purposeIDs.isEmpty
            && featureIDs.isEmpty
            && searchText.isEmpty
    }

    func isSelected(purpose: Purpose) -> Bool {
        return purposeIDs.contains(purpose.id)
    }

    func isSelected(feature: Feature) -> Bool {
        return featureIDs.contains(feature.id)
    }

    mutating func toggle(purpose: Purpose) {
        if !purposeIDs.insert(purpose.id).inserted {
            purposeIDs.remove(purpose.id)
        }
    }

    mutating func toggle(feature: Feature) {
        if !featureIDs.insert(feature.id).inserted {
            featureIDs.remove(feature.id)
        }
    }

    mutating func applySearchText(_ searchText: String) {
        self.searchText = searchText
    }
}
