//
//  SupabaseService.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import Foundation
import Supabase

final class SupabaseService {
    static let client = SupabaseClient(
        supabaseURL: URL(
            string: "https://nruhybkftqynoeaybbcc.supabase.co"
        )!,
        supabaseKey: "sb_publishable_rSuAh2Vx6FtR2ZVTG8sKKw_DvyKTnFl"
    )

    private init() {
    }
}
