//
//  Purpose.swift
//  FindMySpot
//
//  Created by josiaschweizer on 27.09.2026.
//

import Foundation

struct Purpose: Codable, Identifiable {
    let id: UUID
    let slug: String
    let name: String?
    let icon: String?
    let sortOrder: Int
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey{
        case id
        case slug
        case name
        case icon
        case sortOrder = "sort_order"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
