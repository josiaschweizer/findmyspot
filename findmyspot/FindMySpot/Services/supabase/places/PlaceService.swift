//
//  PlaceService.swift
//  FindMySpot
//

import Supabase

enum PlaceService {
    static func create(_ place: PlaceDraft, features: Set<AddPlaceFeature>) async throws {
        let response: CreatedPlace = try await SupabaseService.client
            .from("places")
            .insert(place)
            .select("id")
            .single()
            .execute()
            .value

        let featureDrafts = features.map { $0.draft(placeId: response.id) }

        guard !featureDrafts.isEmpty else {
            return
        }

        try await SupabaseService.client
            .from("place_features")
            .insert(featureDrafts)
            .execute()
    }
}
