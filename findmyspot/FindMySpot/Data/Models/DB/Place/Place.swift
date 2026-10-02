//
//  Place.swift
//  FindMySpot
//
//  Created by josiaschweizer on 27.09.2026.
//

import CoreLocation
import Foundation

struct Place: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String?
    let categoryId: UUID

    let latitude: Double
    let longitude: Double

    let address: String?
    let postalCode: String?
    let city: String?

    let createdBy: UUID?  // has to be nullabel bc when a user gets deleted we don't also have to delete the places he created -> so we just set the ID null
    let status: PlaceStatus

    let createdAt: Date
    let updatedAt: Date

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case categoryId = "category_id"

        case latitude
        case longitude

        case address
        case postalCode = "postal_code"
        case city

        case createdBy = "created_by"
        case status

        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
