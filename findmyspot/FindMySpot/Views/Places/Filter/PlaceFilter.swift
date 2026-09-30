//
//  PlaceFilter.swift
//  FindMySpot
//
//  Created by josiaschweizer on 29.09.2026.
//

import Foundation

struct PlaceFilter {
    var purposeIDs: Set<UUID> = []
    var featureIDs: Set<UUID> = []

    var isEmpty: Bool {
        purposeIDs.isEmpty && featureIDs.isEmpty
    }
}
