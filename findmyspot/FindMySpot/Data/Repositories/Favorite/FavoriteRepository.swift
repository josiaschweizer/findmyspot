import Foundation
//
//  FavoriteRepository.swift
//  FindMySpot
//
//  Created by josiaschweizer on 01.10.2026.
//
import Supabase

struct FavoriteRepository {
    private var supabase: SupabaseClient

    init(supabase: SupabaseClient = SupabaseService.client) {
        self.supabase = supabase
    }

    func getByPlaceId(placeId: UUID) async throws -> Favorite? {
        let user = try await supabase.auth.user()

        let favorites: [Favorite] =
            try await supabase
            .from(FindMySpotEntities.Favorite.rawValue)
            .select()
            .eq("user_id", value: user.id.uuidString)
            .eq("place_id", value: placeId.uuidString)
            .limit(1)
            .execute()
            .value

        return favorites.first
    }

    func getAll() async throws -> [Favorite] {
        let user = try await supabase.auth.user()
        
        return try await getAll(user.id)
    }

    func getAll(_ userId: UUID) async throws -> [Favorite] {
        return
            try await supabase
            .from(FindMySpotEntities.Bookmark.rawValue)
            .select()
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
    }

    func create(placeId: UUID) async throws {
        let user = try await supabase.auth.user()

        try await supabase
            .from(FindMySpotEntities.Favorite.rawValue)
            .insert([
                "user_id": user.id.uuidString,
                "place_id": placeId.uuidString,
            ])
            .execute()
    }

    func deleteByPlaceId(placeId: UUID) async throws {
        let user = try await supabase.auth.user()

        try await supabase
            .from(FindMySpotEntities.Favorite.rawValue)
            .delete()
            .eq("user_id", value: user.id.uuidString)
            .eq("place_id", value: placeId.uuidString)
            .execute()
    }
}
