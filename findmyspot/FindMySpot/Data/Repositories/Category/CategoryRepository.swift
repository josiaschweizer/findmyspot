//
//  CategoryRepository.swift
//  FindMySpot
//
//  Created by josiaschweizer on 28.09.2026.
//

import Foundation
import Supabase

struct CategoryRepository {

    private let supabase: SupabaseClient

    init(supabase: SupabaseClient = SupabaseService.client) {
        self.supabase = supabase
    }

    func getAll() async throws -> [Category] {
        try await supabase
            .from(FindMySpotEntities.Category.rawValue)
            .select()
            .execute()
            .value
    }
}
