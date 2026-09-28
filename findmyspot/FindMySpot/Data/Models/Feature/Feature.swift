//
//  Feature.swift
//  FindMySpot
//
//  Created by josiaschweizer on 27.09.2026.
//

import Foundation

struct Feature: Codable, Identifiable {
    let id: UUID
    let slug: String
    let name: String?
    let type: FeatureType
    let icon: String?
    let sortOrder: Int
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case type
        case icon
        case sortOrder = "sort_order"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
