//
//  Bookmark.swift
//  FindMySpot
//
//  Created by josiaschweizer on 27.09.2026.
//

import Foundation

struct Bookmark: Codable {
    let userId: UUID
    let placeId: UUID
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case placeId = "place_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
