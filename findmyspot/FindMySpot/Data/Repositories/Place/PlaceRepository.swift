//
//  PlaceRepository.swift
//  FindMySpot
//
//  Created by josiaschweizer on 27.09.2026.
//

import Foundation
import Supabase

struct PlaceLocationParms: Encodable {
    let purposeIDs: [UUID]
    let featureIDs: [UUID]
    let searchText: String?

    enum CodingKeys: String, CodingKey {
        case purposeIDs = "purpose_ids"
        case featureIDs = "feature_ids"
        case searchText = "search_text"
    }
}

final class PlaceRepository {

    private let supabase: SupabaseClient

    init(supabase: SupabaseClient = SupabaseService.client) {
        self.supabase = supabase
    }

    func getAll() async throws -> [Place] {
        try await getAll(placeFilter: PlaceFilter())
    }

    func getAll(placeFilter: PlaceFilter) async throws -> [Place] {
        let params = PlaceLocationParms(
            purposeIDs: Array(placeFilter.purposeIDs),
            featureIDs: Array(placeFilter.featureIDs),
            searchText: placeFilter.searchText
        )

        return
            try await supabase
            .rpc(FindMySpotFunctions.places_location.rawValue, params: params)  // we have to use a special rpc-function so that the data is provided in the correct data format (with latitude & longitude)
            .execute()
            .value
    }

}
