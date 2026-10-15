//
//  AddPlaceViewModel.swift
//  FindMySpot
//

internal import Auth
import Foundation
import Observation
import Supabase

@MainActor
@Observable
final class AddPlaceViewModel {
    var name = ""
    var addressDescription = ""
    var details = ""
    var selectedActivities: Set<PlaceActivity> = []
    var selectedFeatures: Set<AddPlaceFeature> = []
    var latitude = 47.4250
    var longitude = 9.3770

    private(set) var isSubmitting = false
    private(set) var errorMessage: String?

    var canContinueFromIdea: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !addressDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func toggle(_ activity: PlaceActivity) {
        if selectedActivities.contains(activity) {
            selectedActivities.remove(activity)
        } else {
            selectedActivities.insert(activity)
        }
    }

    func toggle(_ feature: AddPlaceFeature) {
        if selectedFeatures.contains(feature) {
            selectedFeatures.remove(feature)
        } else {
            selectedFeatures.insert(feature)
        }
    }

    func updatePosition(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    func clearError() {
        errorMessage = nil
    }

    func submit() async -> Bool {
        isSubmitting = true
        errorMessage = nil

        defer {
            isSubmitting = false
        }

        do {
            let user = try await SupabaseService.client.auth.session.user
            let draft = PlaceDraft(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                description: databaseDescription,
                categoryId: inferredCategoryId,
                location: "POINT(\(longitude) \(latitude))",
                address: addressDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                createdBy: user.id,
                status: "pending"
            )

            try await PlaceService.create(draft, features: selectedFeatures)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    private var databaseDescription: String {
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)
        let activities = selectedActivities.map(\.title).sorted()

        guard !activities.isEmpty else {
            return trimmedDetails
        }

        return "\(trimmedDetails)\n\nGeeignet für: \(activities.joined(separator: ", "))"
    }

    private var inferredCategoryId: String {
        if selectedActivities.contains(.studying) {
            return "0ab89bc0-8c52-5e82-bbb0-9f96475dfde5"
        }
        if selectedActivities.contains(.walking) {
            return "017b0e72-33c1-5429-a9ab-99524ba8b6bc"
        }
        if selectedFeatures.contains(.greenery) {
            return "22222222-2222-2222-2222-222222222222"
        }
        return "1c5d788b-031e-5a92-b954-c388d372b2b6"
    }
}
