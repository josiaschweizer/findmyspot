//
//  PlacesViewModel.swift
//  FindMySpot
//
//  Created by josiaschweizer on 28.09.2026.
//

import Combine
import Foundation
import OSLog

@MainActor
final class PlacesViewModel: ObservableObject {
    @Published private(set) var places: [Place] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var filter = PlaceFilter()

    private var latestRequestID: UUID?
    private var lastLoadedFilter: PlaceFilter?

    private let logger: Logger
    private let placeRepository: PlaceRepository

    private var hasLoaded = false

    init() {
        self.placeRepository = PlaceRepository()
        self.logger = Logger(subsystem: "FindMySpot", category: "Places")
    }

    func apply(_ newFilter: PlaceFilter) async {
        var updated = newFilter
        updated.applySearchText(filter.searchText)

        filter = updated
        await loadPlaces()
    }

    func search(_ text: String) async {
        let trimmed = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        filter.applySearchText(trimmed)
        await loadPlaces()
    }

    func loadIfNeeded() async {
        guard !hasLoaded else {
            return
        }

        await loadPlaces()
    }

    func loadPlaces() async {
        guard !Task.isCancelled else {
            return
        }

        // skip only if the displayed resultst already match and no other request could still replace them
        if !isLoading && lastLoadedFilter == filter {
            return
        }

        let requestID = UUID()
        let requestedFilter = filter

        latestRequestID = requestID
        isLoading = true
        errorMessage = nil

        defer {
            // an older request must not stop the current loading indicator
            if latestRequestID == requestID {
                isLoading = false
            }
        }

        do {
            let loadedPlaces = try await placeRepository.getAll(
                placeFilter: requestedFilter
            )

            try Task.checkCancellation()

            // in case while we were fetching another laodPlaces() got called, we return
            guard latestRequestID == requestID else {
                return
            }

            places = loadedPlaces
            lastLoadedFilter = requestedFilter
            hasLoaded = true
        } catch {
            guard latestRequestID == requestID && !Task.isCancelled else {
                return
            }

            logger.error(
                "Error occured while loading Places: \(error.localizedDescription, privacy: .private)"
            )

            errorMessage = "The Places couldn't be loaded."
        }
    }

    func setBookmark(_ value: Bool, for placeId: UUID) {
        guard let index = places.firstIndex(where: { $0.id == placeId }) else {
            return
        }

        places[index].isBookmark = value
    }

    func setFavorite(_ value: Bool, for placeId: UUID) {
        guard let index = places.firstIndex(where: { $0.id == placeId }) else {
            return
        }

        places[index].isFavorite = value
    }

}
