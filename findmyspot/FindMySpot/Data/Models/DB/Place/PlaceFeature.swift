//
//  PlaceFeature.swift
//  FindMySpot
//
//  Created by josiaschweizer on 27.09.2026.
//

import Foundation

struct PlaceFeature: Codable {
    let placeId: UUID
    let featureId: UUID
    let booleanValue: Bool?
    let ratingValue: Int?
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case featureId = "feature_id"
        case booleanValue = "boolean_value"
        case ratingValue = "rating_value"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
