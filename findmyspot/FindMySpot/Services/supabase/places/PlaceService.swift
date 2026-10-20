//
//  PlaceService.swift
//  FindMySpot
//

import Foundation
import Supabase

enum PlaceService {
    static func create(
        _ place: PlaceDraft,
        activities: Set<UUID>,
        features: Set<AddPlaceFeature>
    ) async throws {
        let response: CreatedPlace = try await SupabaseService.client
            .from("places")
            .insert(place)
            .select("id")
            .single()
            .execute()
            .value

        let featureDrafts = features.map { $0.draft(placeId: response.id) }
        if !featureDrafts.isEmpty {
            try await SupabaseService.client
                .from(FindMySpotEntities.PlaceFeature.rawValue)
                .insert(featureDrafts)
                .execute()
        }

        let activityDrafts = activities.map {
            PlacePurpose(placeId: response.id, purposeId: $0)
        }
        if !activityDrafts.isEmpty {
            try await SupabaseService.client
                .from(FindMySpotEntities.PlacePurpose.rawValue)
                .insert(activityDrafts)
                .execute()
        }
    }
}
