import Foundation
//
//  PlaceFeatureRepository.swift
//  FindMySpot
//
//  Created by josiaschweizer on 01.10.2026.
//
import Supabase

struct PlaceFeatureRepository {
    private var supabase: SupabaseClient

    init(supabase: SupabaseClient = SupabaseService.client) {
        self.supabase = supabase
    }

    func getFeaturesByPlace(placeID: UUID) async throws -> [Feature] {
        try await supabase
            .from(FindMySpotEntities.PlaceFeature.rawValue)
            .select()
            .eq("place_id", value: placeID.uuidString)
            .order("id", ascending: true)
            .select()
            .execute()
            .value
    }
}
