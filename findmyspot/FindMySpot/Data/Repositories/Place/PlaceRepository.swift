//
//  PlaceRepository.swift
//  FindMySpot
//
//  Created by josiaschweizer on 27.09.2026.
//

import Supabase
import Foundation

final class PlaceRepository {

    private let supabase: SupabaseClient

    init(supabase: SupabaseClient = SupabaseService.client) {
        self.supabase = supabase
    }

    func getAll() async throws -> [Place] {
        try await supabase
            .rpc(FindMySpotFunctions.places_location.rawValue) // we have to use a special rpc-function so that the data is provided in the correct data format (with latitude & longitude)
            .execute()
            .value
    }
}
