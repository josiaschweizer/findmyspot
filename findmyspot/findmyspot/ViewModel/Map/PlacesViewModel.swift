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

        guard newFilter != filter else {
            return
        }
        filter = updated
        await loadPlaces()
    }

    func search(_ text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed != filter.searchText else {
            return
        }

        filter.applySearchText(text)
        await loadPlaces()
    }

    func loadIfNeeded() async {
        guard !hasLoaded else {
            return
        }

        await loadPlaces()
    }

    func loadPlaces() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let loadedPlaces = try await fetchPlaces()
            try Task.checkCancellation()

            places = loadedPlaces
            hasLoaded = true
        } catch {
            guard !Task.isCancelled else {
                return
            }

            logger.error(
                "Error occured while loading Places: \(error.localizedDescription, privacy: .private)"
            )

            errorMessage = "The Places couldn't be loaded."
        }
    }

    private func fetchPlaces() async throws -> [Place] {
        return try await placeRepository.getAll(placeFilter: filter)
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
