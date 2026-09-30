//
//  FeatureRepository.swift
//  FindMySpot
//
//  Created by josiaschweizer on 30.09.2026.
//
import Supabase

struct FeatureRepository {
    private var supabase: SupabaseClient

    init(supabase: SupabaseClient = SupabaseService.client) {
        self.supabase = supabase
    }

    func getAll() async throws -> [Feature] {
        try await supabase
            .from(FindMySpotEntities.Feature.rawValue)
            .select()
            .order("sort_order", ascending: false)
            .execute()
            .value
    }
}
