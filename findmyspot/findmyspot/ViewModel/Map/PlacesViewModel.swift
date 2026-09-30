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

    private let fetchPlaces: @MainActor () async throws -> [Place]
    private var hasLoaded = false

    private let logger: Logger

    init(
        fetchPlaces: @escaping @MainActor () async throws -> [Place]
    ) {
        self.fetchPlaces = fetchPlaces
        self.logger = Logger(subsystem: "FindMySpot", category: "Places")
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

}
