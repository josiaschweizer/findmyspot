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
    }

    @Published private(set) var states: [UUID: State] = [:]

    private let favoriteRepository = FavoriteRepository()
    private let bookmarkRepository = BookmarkRepository()

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
