//
//  PlacePurpose.swift
//  FindMySpot
//
//  Created by josiaschweizer on 27.09.2026.
//

import Foundation

struct PlacePurpose: Codable {
    let placeId: UUID
    let purposeId: UUID

    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case purposeId = "purpose_id"
    }
}
