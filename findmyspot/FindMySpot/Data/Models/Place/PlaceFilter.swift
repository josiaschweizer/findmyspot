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

    var isEmpty: Bool {
        return purposeIDs.isEmpty && featureIDs.isEmpty
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

    mutating func reset() {
        purposeIDs.removeAll()
        featureIDs.removeAll()
    }
}
