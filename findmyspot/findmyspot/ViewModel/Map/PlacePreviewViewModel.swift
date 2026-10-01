//
//  PlacePreviewViewModel.swift
//  FindMySpot
//
//  Created by josiaschweizer on 01.10.2026.
//
import Combine
import Foundation

@MainActor
final class PlacePreviewViewModel: ObservableObject {
    @Published private(set) var imageURL: URL?
    @Published private(set) var featureNames: [String]
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let featureRepository: FeatureRepository
    private let placeImageRepository: PlaceImageRepository
    private let placeFeatureRepository: PlaceFeatureRepository

    init() {
        self.featureRepository = FeatureRepository()
        self.placeImageRepository = PlaceImageRepository()
        self.placeFeatureRepository = PlaceFeatureRepository()

        self.imageURL = nil
        self.featureNames = []
    }

    func load(placeID: UUID) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = nil
        imageURL = nil
        featureNames = []

        defer {
            isLoading = false
        }

        do {
            imageURL = try await loadImageUrl(placeID: placeID)
            featureNames = try await loadFeatureNames(placeID: placeID)
        } catch {
            guard !Task.isCancelled else {
                return
            }
            errorMessage = "The place details could not be loaded"
        }
    }

    private func loadImageUrl(placeID: UUID) async throws -> URL? {
        let url = try await placeImageRepository.getPreviewUrl(placeID: placeID)
        try Task.checkCancellation()
        return url
    }

    private func loadFeatureNames(placeID: UUID) async throws -> [String] {
        let placeFeatures = try await placeFeatureRepository.getFeaturesByPlace(
            placeID: placeID
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
}
