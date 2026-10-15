//
//  PlaceDraft.swift
//  FindMySpot
//

import Foundation

enum PlaceActivity: String, CaseIterable, Codable, Identifiable {
    case studying
    case relaxing
    case meeting
    case waiting
    case walking

    var id: Self { self }

    var title: String {
        switch self {
        case .studying: "Lernen"
        case .relaxing: "Entspannen"
        case .meeting: "Treffen"
        case .waiting: "Warten"
        case .walking: "Spazieren"
        }
    }
}

enum AddPlaceFeature: String, CaseIterable, Codable, Identifiable {
    case quiet
    case seating
    case wifi
    case powerOutlet = "power_outlet"
    case weatherProtection = "weather_protection"
    case toilet
    case accessible
    case greenery
    case view

    var id: Self { self }

    var title: String {
        switch self {
        case .quiet: "Ruhig"
        case .seating: "Sitzplätze"
        case .wifi: "WLAN"
        case .powerOutlet: "Steckdose"
        case .weatherProtection: "Wetterschutz"
        case .toilet: "WC"
        case .accessible: "Barrierearm"
        case .greenery: "Im Grünen"
        case .view: "Aussicht"
        }
    }
}

struct PlaceDraft: Encodable {
    let name: String
    let description: String
    let categoryId: String
    let location: String
    let address: String
    let createdBy: UUID

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case categoryId = "category_id"
        case location
        case address
        case createdBy = "created_by"
    }
}

nonisolated struct CreatedPlace: Decodable {
    let id: UUID
}

struct PlaceFeatureDraft: Encodable {
    let placeId: UUID
    let featureId: String
    let booleanValue: Bool?
    let ratingValue: Int?

    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case featureId = "feature_id"
        case booleanValue = "boolean_value"
        case ratingValue = "rating_value"
    }
}

extension AddPlaceFeature {
    var databaseId: String {
        switch self {
        case .wifi:
            "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1"
        case .powerOutlet:
            "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2"
        case .quiet:
            "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3"
        case .seating:
            "0ca351d7-ecda-5297-af76-1c5c92fde99f"
        case .weatherProtection:
            "4e3ee537-0f95-58ae-9de3-2cbc7f94dc26"
        case .toilet:
            "53afada3-e012-5bfd-af12-beb1670068f8"
        case .accessible:
            "ac75a29b-a228-55c7-8220-d55211d9ef2a"
        case .greenery:
            "4d441d69-5fae-5713-9ff4-2ff3c84017e2"
        case .view:
            "9db62fde-1e31-5fca-b412-42a368d047de"
        }
    }

    func draft(placeId: UUID) -> PlaceFeatureDraft {
        PlaceFeatureDraft(
            placeId: placeId,
            featureId: databaseId,
            booleanValue: self == .quiet ? nil : true,
            ratingValue: self == .quiet ? 5 : nil
        )
    }
}
