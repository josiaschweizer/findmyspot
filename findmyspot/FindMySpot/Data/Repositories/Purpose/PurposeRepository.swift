//
//  PurposeRepository.swift
//  FindMySpot
//
//  Created by josiaschweizer on 30.09.2026.
//
import Supabase

struct PurposeRepository {
    private let supabase: SupabaseClient

    init(supabase: SupabaseClient = SupabaseService.client) {
        self.supabase = supabase
    }

    func getAll() async throws -> [Purpose] {
        try await supabase
            .from(FindMySpotEntities.Purpose.rawValue)
            .select()
            .order("sort_order", ascending: false)
            .execute()
            .value
    }
}
