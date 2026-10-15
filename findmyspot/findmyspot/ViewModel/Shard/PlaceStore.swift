//
//  PlaceInteractionStore.swift
//  FindMySpot
//
//  Created by josiaschweizer on 11.10.2026.
//

import Combine
import Foundation

@MainActor
final class PlaceStore: ObservableObject {
    struct State {
        var isFavorite: Bool
        var isBookmark: Bool
        var isFavoritesSaving = false
        var isBookmarksSaving = false

        var imageURL: URL?
        var featureNames: [String] = []

        var isLoadingDetails = false
        var detailsError: String?
        var detailsLoadedAt: Date?
    }

    @Published private(set) var states: [UUID: State] = [:]

    private let featureRepository = FeatureRepository()
    private let imageRepository = PlaceImageRepository()
    private let placeFeatureRepository = PlaceFeatureRepository()
    private let favoriteRepository = FavoriteRepository()
    private let bookmarkRepository = BookmarkRepository()

    private var detailTasks: [UUID: Task<Void, Never>] = [:]

    private var cachedFeatures: [Feature]?
    private var featuresLoadedAt: Date?
    private var featureTasks: Task<[Feature], Error>?

    private let detailsLifetime: TimeInterval = 50 * 60

    func register(_ places: [Place]) {
        for place in places where states[place.id] == nil {
            states[place.id] = State(
                isFavorite: place.isFavorite,
                isBookmark: place.isBookmark
            )
        }
    }

    func state(for place: Place) -> State {
        states[place.id]
            ?? State(
                isFavorite: place.isFavorite,
                isBookmark: place.isBookmark
            )
    }

    func loadDetails(for place: Place, force: Bool = false) async {
        register([place])

        if let task = detailTasks[place.id] {
            await task.value
            return
        }

        if !force,
            let loadedAt = states[place.id]?.detailsLoadedAt,
            Date().timeIntervalSince(loadedAt) < detailsLifetime
        {
            return
        }

        states[place.id]?.isLoadingDetails = true
        states[place.id]?.detailsError = nil

        let task = Task { @MainActor in
            defer {
                self.states[place.id]?.isLoadingDetails = false
                self.detailTasks[place.id] = nil
            }

            let requestedAt = Date()

            var failures: [String] = []

            do {
                let imageURL = try await imageRepository.getPreviewUrl(
                    placeId: place.id
                )

                self.states[place.id]?.imageURL = imageURL
            } catch {
                failures.append("The image could not be loaded.")
            }

            do {
                let assignments =
                    try await placeFeatureRepository.getFeaturesByPlace(
                        placeId: place.id
                    )

                let selectedIDs = Set(
                    assignments
                        .filter { $0.booleanValue == true }
                        .map(\.featureId)
                )

                var names: [String] = []

                if !selectedIDs.isEmpty {
                    let features = try await loadFeatureCatalog()

                    names =
                        features
                        .filter {
                            selectedIDs.contains($0.id) && $0.type == .boolean
                        }
                        .sorted { $0.sortOrder < $1.sortOrder }
                        .map { $0.name ?? $0.slug }
                }

                states[place.id]?.featureNames = names
            } catch {
                failures.append("The features could no be loaded.")
            }

            if failures.isEmpty {
                states[place.id]?.detailsLoadedAt = requestedAt
                states[place.id]?.detailsError = nil
            } else {
                states[place.id]?.detailsLoadedAt = nil
                states[place.id]?.detailsError = failures.joined(
                    separator: StringUtil.SPACE
                )
            }
        }

        detailTasks[place.id] = task
        await task.value
    }

    private func loadFeatureCatalog() async throws -> [Feature] {
        if let cachedFeatures,
            let featuresLoadedAt,
            Date().timeIntervalSince(featuresLoadedAt) < detailsLifetime
        {
            return cachedFeatures
        }

        if let featureTasks {
            return try await featureTasks.value
        }

        let task = Task { @MainActor in
            try await featureRepository.getAll()
        }

        featureTasks = task

        defer {
            featureTasks = nil
        }

        let features = try await task.value
        
        cachedFeatures = features
        featuresLoadedAt = Date()

        return features
    }

    func toggleFavorite(
        placeId: UUID,
        userNotifier: UserNotifier
    ) {
        guard let current = states[placeId],
            !current.isFavoritesSaving
        else {
            return
        }

        let previous = current.isFavorite
        let target = !previous

        states[placeId]?.isFavoritesSaving = true
        states[placeId]?.isFavorite = target

        Task {
            defer {
                states[placeId]?.isFavoritesSaving = false
            }

            do {
                if target {
                    try await favoriteRepository.create(placeId: placeId)
                } else {
                    try await favoriteRepository.deleteByPlaceId(
                        placeId: placeId
                    )
                }
            } catch {
                states[placeId]?.isFavorite = previous

                // show user hint
                userNotifier.error(
                    "The favorite could not be updated."
                )
            }
        }
    }

    func toggleBookmark(
        placeId: UUID,
        userNotifier: UserNotifier
    ) {
        guard let current = states[placeId],
            !current.isBookmarksSaving
        else {
            return
        }

        let previous = current.isBookmark
        let target = !previous

        states[placeId]?.isBookmarksSaving = true
        states[placeId]?.isBookmark = target

        Task {
            defer {
                states[placeId]?.isBookmarksSaving = false
            }

            do {
                if target {
                    try await bookmarkRepository.create(placeId: placeId)
                } else {
                    try await bookmarkRepository.deleteByPlaceId(
                        placeId: placeId
                    )
                }
            } catch {
                states[placeId]?.isBookmark = previous

                // show user hint
                userNotifier.error("The bookmark could not be updated.")
            }
        }
    }

    func applyingState(to place: Place) -> Place {
        let current = state(for: place)

        var result = place
        result.isFavorite = current.isFavorite
        result.isBookmark = current.isBookmark
        return result
    }
}
