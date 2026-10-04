import Foundation
//
//  PlaceImageRepository.swift
//  FindMySpot
//
//  Created by josiaschweizer on 01.10.2026.
//
import Supabase

struct PlaceImageRepository {
    private var supabase: SupabaseClient

    private struct ImageRow: Decodable {
        let storagePath: String

        enum CodingKeys: String, CodingKey {
            case storagePath = "storage_path"
        }
    }

    init(supabase: SupabaseClient = SupabaseService.client) {
        self.supabase = supabase
    }

    func getPreviewUrl(placeId: UUID) async throws -> URL? {
        let images: [ImageRow] =
            try await supabase
            .from(FindMySpotEntities.PlaceImage.rawValue)
            .select("storage_path")
            .eq("place_id", value: placeId.uuidString)
            .order("sort_order", ascending: true)
            .order("id", ascending: true)
            .limit(1)
            .execute()
            .value

        guard let image = images.first else {
            return nil
        }

        return try await supabase.storage
            .from("place-images")
            .createSignedURL(
                path: image.storagePath,
                expiresIn: 3600
            )

    }

}
