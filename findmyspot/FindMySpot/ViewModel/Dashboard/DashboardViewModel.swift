//
//  DashboardViewModel.swift
//  FindMySpot
//
//  Created by josiaschweizer on 11.10.2026.
//
import Combine
import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published private(set) var places: [Place] = []
    @Published private(set) var details: [UUID: PlaceCardDetails] = [:]
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let placeRepository = PlaceRepository()
    private let featureRepository = FeatureRepository()
    private let placeImageRepository = PlaceImageRepository()
    private let placeFeatureRepository = PlaceFeatureRepository()

    private var features: [Feature] = []
    private var loadingDetails: Set<UUID> = []

    var favorites: [Place] {
        sorted(places.filter(\.isFavorite))
    }

    var bookmarks: [Place] {
        sorted(places.filter(\.isBookmark))
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

        do {
            let loadedPlaces = try await placeRepository.getAll()
            let loadedFeatures = try await featureRepository.getAll()

            try Task.checkCancellation()

            places = loadedPlaces
            features = loadedFeatures
            details = [:]
        } catch {
            guard !Task.isCancelled else {
                return
            }

            errorMessage = "The saved places could not be loaded"
        }
    }

    func loadDetails(for placeID: UUID) async {
        guard details[placeID] == nil && !loadingDetails.contains(placeID)
        else {
            return
        }

        loadingDetails.insert(placeID)

        defer {
            loadingDetails.remove(placeID)
        }

        // load the image url
        let imageURL = try? await placeImageRepository.getPreviewUrl(
            placeId: placeID
        )

        guard !Task.isCancelled else {
            return
        }

        // load the features for the place
        let assignments = try? await placeFeatureRepository.getFeaturesByPlace(
            placeId: placeID
        )

        guard !Task.isCancelled else {
            return
        }

        let selectedIDs = Set(
            (assignments ?? [])
                .filter { $0.booleanValue == true }
                .map(\.featureId)
        )

        // map for filter names to display
        let names =
            features
            .filter {
                selectedIDs.contains($0.id) && $0.type == .boolean
            }
            .sorted { $0.sortOrder < $1.sortOrder }
            .map { $0.name ?? $0.slug }

        details[placeID] = PlaceCardDetails(
            imageURL: imageURL,
            featureNames: names
        )
    }

    private func sorted(_ places: [Place]) -> [Place] {
        places.sorted {
            let comparison = $0.name.localizedStandardCompare($1.name)

            if comparison == .orderedSame {
                return $0.id.uuidString < $1.id.uuidString
            }

            return comparison == .orderedAscending
        }
    }
}
