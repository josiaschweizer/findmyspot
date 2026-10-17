//
//  ProfileRepository.swift
//  FindMySpot
//
//  Created by josiaschweizer on 13.10.2026.
//
import Foundation
import Supabase

struct ProfileRepository {
    private var supabase: SupabaseClient

    init(supabase: SupabaseClient = SupabaseService.client) {
        self.supabase = supabase
    }

    func getCurrent() async throws -> Profile {
        let user = try await supabase.auth.user()

        return
            try await supabase
            .from(FindMySpotEntities.Profile.rawValue)
            .select()
            .eq("id", value: user.id.uuidString)
            .single()
            .execute()
            .value
    }

    func updateDisplayName(_ displayName: String) async throws {
        let user = try await supabase.auth.user()

        try await supabase
            .from(FindMySpotEntities.Profile.rawValue)
            .update(["display_name": displayName])
            .eq("id", value: user.id.uuidString)
            .execute()
    }
}
