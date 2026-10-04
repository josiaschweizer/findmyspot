//
//  PlacePreviewViewModel.swift
//  FindMySpot
//
//  Created by josiaschweizer on 01.10.2026.
//
import Combine
import Foundation
import SwiftUI

@MainActor
final class PlacePreviewViewModel: ObservableObject {
    @Published private(set) var imageURL: URL?
    @Published private(set) var featureNames: [String]
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    @Published private(set) var isFavorite = false
    @Published private(set) var isFavoritesSaving = false
    @Published private(set) var isBookmark = false
    @Published private(set) var isBookmarksSaving = false

    private var currentPlaceId: UUID?

    private let featureRepository: FeatureRepository
    private let bookmarkRepository: BookmarkRepository
    private let favoriteRepository: FavoriteRepository
    private let placeImageRepository: PlaceImageRepository
    private let placeFeatureRepository: PlaceFeatureRepository

    init() {
        self.featureRepository = FeatureRepository()
        self.bookmarkRepository = BookmarkRepository()
        self.favoriteRepository = FavoriteRepository()
        self.placeImageRepository = PlaceImageRepository()
        self.placeFeatureRepository = PlaceFeatureRepository()

        self.imageURL = nil
        self.featureNames = []
    }

    func load(placeId: UUID) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = nil
        imageURL = nil
        featureNames = []

        currentPlaceId = placeId

        defer {
            isLoading = false
        }

        do {
            imageURL = try await loadImageUrl(placeId: placeId)
            isFavorite = try await loadIsFavorite(placeId: placeId)
            isBookmark = try await loadIsBookmark(placeId: placeId)
            featureNames = try await loadFeatureNames(placeId: placeId)
        } catch {
            guard !Task.isCancelled else {
                return
            }
            errorMessage = "The place details could not be loaded"
        }
    }

    private func loadImageUrl(placeId: UUID) async throws -> URL? {
        let url = try await placeImageRepository.getPreviewUrl(placeId: placeId)
        try Task.checkCancellation()
        return url
    }

    private func loadFeatureNames(placeId: UUID) async throws -> [String] {
        let placeFeatures = try await placeFeatureRepository.getFeaturesByPlace(
            placeId: placeId
        )

        try Task.checkCancellation()

        let selectedIDs = Set(
            placeFeatures
                .filter { $0.booleanValue == true }
                .map { $0.featureId }
        )

        guard !selectedIDs.isEmpty else {
            return []
        }

        let features = try await featureRepository.getAll()
        try Task.checkCancellation()

        return
            features
            .filter { selectedIDs.contains($0.id) && $0.type == .boolean }
            .sorted { $0.sortOrder < $1.sortOrder }
            .map { $0.name ?? $0.slug }
    }

    private func loadIsFavorite(placeId: UUID) async throws -> Bool {
        return try await favoriteRepository.getByPlaceId(placeId: placeId)
            != nil
    }

    private func loadIsBookmark(placeId: UUID) async throws -> Bool {
        return try await bookmarkRepository.getByPlaceId(placeId: placeId)
            != nil
    }

    func toggleFavorite(
        placeId: UUID,
        userNotifier: UserNotifier,
        onChange: @escaping (Bool) -> Void
    ) {
        guard !isFavoritesSaving else {
            return
        }

        let previous = isFavorite
        let target = !previous

        isFavorite = target
        onChange(target)
        isFavoritesSaving = true

        Task {
            defer {
                isFavoritesSaving = false
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
                guard currentPlaceId == placeId else {
                    return
                }
                // revert ui state to db state
                isFavorite = previous
                onChange(previous)
                
                // show user information
                userNotifier.error("The favorite could not be updated.")
            }
        }
    }

    func toggleBookmark(
        placeId: UUID,
        userNotifier: UserNotifier,
        onChange: @escaping (Bool) -> Void
    ) {
        guard !isBookmarksSaving else {
            return
        }

        let previous = isBookmark
        let target = !previous

        isBookmark = target
        onChange(target)
        isBookmarksSaving = true

        Task {
            defer {
                isBookmarksSaving = false
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
                guard currentPlaceId == placeId else {
                    return
                }
                
                // revert ui state to db state
                isBookmark = previous
                onChange(previous)
                
                // show user information
                userNotifier.error("The bookmark could not be updated.")
            }
        }
    }

}
