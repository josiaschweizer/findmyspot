//
//  AuthViewModel.swift
//  findmyspot
//
//  Created by Josia Schweizer on 12.09.2026.
//

internal import Auth
import Foundation
import Observation
import Supabase

@MainActor
@Observable
final class AuthViewModel {
    enum State {
        case loading
        case signedOut
        case signedIn
    }

    private(set) var state: State = .loading
    private(set) var isSubmitting = false

    var errorMessage: String?
    var signUpMessage: String?

    private var authTask: Task<Void, Never>?

    init() {
        observeAuthentication()
    }

    private func observeAuthentication() {
        authTask = Task { [weak self] in
            for await (event, session) in SupabaseService.client.auth
                .authStateChanges
            {
                guard let self else {
                    return
                }

                switch event {
                case .initialSession, .signedIn, .signedOut, .tokenRefreshed:
                    state = session == nil ? .signedOut : .signedIn

                default:
                    break
                }
            }
        }
    }

    func signIn(email: String, password: String) async {
        await perform {
            try await AuthService.signIn(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
        }
    }

    func signUp(displayName: String, email: String, password: String) async {
        signUpMessage = nil

        await perform {
            let response = try await AuthService.signUp(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )

            if response.session == nil {
                signUpMessage = "Check your email to confirm you account."
            }
        }

    }

    func signOut() async {
        await perform {
            try await AuthService.signOut()
        }
    }

    private func perform(_ operation: () async throws -> Void) async {
        isSubmitting = true
        errorMessage = nil

        // running at the end of the function -> basically the same as a finally in a try statement in java
        defer {
            isSubmitting = false
        }

        do {
            try await operation()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    isolated deinit {
        authTask?.cancel()
    }
}
