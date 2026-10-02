//
//  PlaceFeatureRepository.swift
//  FindMySpot
//
//  Created by josiaschweizer on 01.10.2026.
//
import Supabase
import Foundation

struct PlaceFeatureRepository {
    private var supabase: SupabaseClient

    init(supabase: SupabaseClient = SupabaseService.client) {
        self.supabase = supabase
    }

    func getFeaturesByPlace(placeId: UUID) async throws -> [PlaceFeature] {
        try await supabase
            .from(FindMySpotEntities.PlaceFeature.rawValue)
            .select()
            .eq("place_id", value: placeId.uuidString)
            .order("feature_id", ascending: true)
            .select()
            .execute()
            .value
    }
}
