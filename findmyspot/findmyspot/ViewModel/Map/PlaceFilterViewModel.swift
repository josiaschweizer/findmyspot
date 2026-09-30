//
//  PlaceFilterViewModel.swift
//  FindMySpot
//
//  Created by josiaschweizer on 30.09.2026.
//
import Combine
import Foundation

@MainActor
final class PlaceFilterViewModel: ObservableObject {
    @Published private(set) var purposes: [Purpose] = []
    @Published private(set) var features: [Feature] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let purposeRepository: PurposeRepository
    private let featureRepository: FeatureRepository

    private var hasLoaded = false

    init() {
        self.purposeRepository = PurposeRepository()
        self.featureRepository = FeatureRepository()
    }

    func loadIfNeeded() async {
        guard !hasLoaded, !isLoading else {
            return
        }

        await load()
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
            let loadedPurposes = try await purposeRepository.getAll()
            let loadedFeatures = try await featureRepository.getAll()

            try Task.checkCancellation()

            purposes = loadedPurposes
            features = loadedFeatures
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
