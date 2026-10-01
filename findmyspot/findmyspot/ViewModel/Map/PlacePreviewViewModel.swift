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

    private let placeImageRepository: PlaceImageRepository
    private let placeFeatureRepository: PlaceFeatureRepository

    init() {
        self.placeImageRepository = PlaceImageRepository()
        self.placeFeatureRepository = PlaceFeatureRepository()

        self.imageURL = nil
        self.featureNames = []
    }

    func load(placeID: UUID) async {
        print("Before load")
        guard !isLoading else {
            return
        }
        
        print("start load")

        isLoading = true
        errorMessage = nil
        imageURL = nil
        featureNames = []

        defer {
            isLoading = false
        }

        print("before load")
        do {
            imageURL = try await loadImageUrl(placeID: placeID)
            print("after image load")
            featureNames = try await loadFeatureNames(placeID: placeID)
            print("after load all")
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
        let features = try await placeFeatureRepository.getFeaturesByPlace(
            placeID: placeID
        )
        try Task.checkCancellation()

        let booleanFeatures = features.filter { $0.type == .boolean }
        let sortedFeatures = booleanFeatures.sorted {
            $0.sortOrder < $1.sortOrder
        }
        return sortedFeatures.map { $0.name ?? $0.slug }
    }
}
