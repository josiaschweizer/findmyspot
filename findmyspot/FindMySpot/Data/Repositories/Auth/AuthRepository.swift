//
//  AuthService.swift
//  findmyspot
//
//  Created by Josia Schweizer on 12.09.2026.
//

import Supabase

enum AuthService {
    static func signIn(email: String, password: String) async throws {
        try await SupabaseService.client.auth.signIn(
            email: email,
            password: password
        )
    }

    static func signUp(email: String, password: String, displayName: String) async throws
        -> AuthResponse
    {
        try await SupabaseService.client.auth.signUp(
            email: email,
            password: password,
            data: ["display_name": .string(displayName)]
        )
    }

    static func signOut() async throws {
        try await SupabaseService.client.auth.signOut()
    }
}
