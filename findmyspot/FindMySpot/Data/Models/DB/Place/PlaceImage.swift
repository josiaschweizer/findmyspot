//
//  PlaceImage.swift
//  FindMySpot
//
//  Created by josiaschweizer on 27.09.2026.
//

import Foundation

struct PlaceImage: Codable, Identifiable {
    let id: UUID
    let placeId: UUID
    let storagePath: String
    let uploadedBy: UUID
    let sortOrder: Int
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case placeId = "place_id"
        case storagePath = "storage_path"
        case uploadedBy = "uploaded_by"
        case sortOrder = "sort_order"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
