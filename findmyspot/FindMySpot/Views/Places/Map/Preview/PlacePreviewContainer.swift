//
//  PlacePreviewContainer.swift
//  FindMySpot
//
//  Created by josiaschweizer on 01.10.2026.
//

import SwiftUI

@MainActor
struct PlacePreviewContainer: View {
    @EnvironmentObject private var interactions: PlaceStore
    @StateObject private var viewModel = PlacePreviewViewModel()

    let place: Place
    let onClose: () -> Void

    var body: some View {
        Group {
            if viewModel.isLoading {
                AppCard {
                    ProgressView()
                        .tint(AppColors.primary)
                        .accessibilityLabel("Loading places details...")
                }
            } else if let message = viewModel.errorMessage {
                VStack(spacing: AppSpacing.sm) {
                    AppCard {
                        VStack(spacing: AppSpacing.sm) {
                            AppErrorMessage(message: message)

                            AppButton(
                                "Try again",
                                action: {
                                    Task {
                                        await viewModel.load(placeId: place.id)
                                    }
                                }
                            )
                        }
                    }
                }
            } else {
                PlacePreviewView(
                    place: place,
                    imageURL: viewModel.imageURL,
                    featureNames: viewModel.featureNames,
                    isFavorite: interactions.state(for: place).isFavorite,
                    isFavoriteSaving: interactions.state(for: place)
                        .isFavoritesSaving,
                    onFavorite: { placeId, notifier in
                        interactions.toggleFavorite(
                            placeId: placeId,
                            userNotifier: notifier
                        )
                    },
                    isBookmark: interactions.state(for: place).isBookmark,
                    isBookmarkSaving: interactions.state(for: place)
                        .isBookmarksSaving,
                    onBookmark: { placeId, notifier in
                        interactions.toggleBookmark(
                            placeId: placeId,
                            userNotifier: notifier
                        )
                    },
                    onClose: onClose
                )
            }
        }
        .task {
            interactions.register([place])
            await viewModel.load(placeId: place.id)
        }
    }
}
