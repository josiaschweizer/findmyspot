//
//  SettingsViewModel.swift
//  FindMySpot
//
//  Created by josiaschweizer on 13.10.2026.
//

internal import Auth
import CoreLocation
import Observation

@MainActor
@Observable
final class SettingsViewModel {
    static let displayNameMaxLength = 40

    private(set) var profile: Profile?
    private(set) var email = StringUtil.EMPTY
    private(set) var locationStatus: LocationPermissionStatus = .notDetermined

    private(set) var isLoading = false
    private(set) var isSaving = false

    var errorMessage: String?

    private let locationManager = CLLocationManager()
    private let profileRepository = ProfileRepository()

    var displayName: String {
        profile?.displayName ?? StringUtil.EMPTY
    }

    var appVersion: String {
        let version =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"]
            as? String ?? "?"
        let build =
            Bundle.main.infoDictionary?["CFBundleVersion"]
            as? String ?? "?"

        return "Version \(version) (\(build))"
    }

    func load() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        refreshLocationStatus()

        do {
            let user = try await AuthRepository.currentUser()
            let loadedProfile = try await profileRepository.getCurrent()

            try Task.checkCancellation()

            email = user.email ?? StringUtil.EMPTY
            profile = loadedProfile
        } catch {
            guard !Task.isCancelled else {
                return
            }

            errorMessage = "Your profile couldn't be loaded."
        }
    }

    func canSave(_ newName: String) -> Bool {
        let trimmed = trim(newName)

        return !isSaving
            && !trimmed.isEmpty
            && trimmed.count <= Self.displayNameMaxLength
            && trimmed != displayName
    }

    func saveDisplayName(_ newName: String) async -> Bool {
        guard canSave(newName) else {
            return false
        }

        isSaving = true

        defer {
            isSaving = false
        }

        do {
            try await profileRepository.updateDisplayName(trim(newName))
            profile = try await profileRepository.getCurrent()
            return true
        } catch {
            return false
        }
    }

    func refreshLocationStatus() {
        locationStatus = LocationPermissionStatus(
            locationManager.authorizationStatus
        )
    }

    private func trim(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}
