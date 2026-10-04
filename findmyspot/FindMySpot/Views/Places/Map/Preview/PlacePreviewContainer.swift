//
//  PlacePreviewContainer.swift
//  FindMySpot
//
//  Created by josiaschweizer on 01.10.2026.
//

import SwiftUI

@MainActor
struct PlacePreviewContainer: View {
    let place: Place
    let onClose: () -> Void
    let onBookmarkChanged: (Bool) -> Void
    let onFavoriteChanged: (Bool) -> Void

    @StateObject private var viewModel = PlacePreviewViewModel()

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
                    isFavorite: viewModel.isFavorite,
                    onFavorite: { placeId, notifier in
                        viewModel.toggleFavorite(
                            placeId: placeId,
                            userNotifier: notifier,
                            onChange: onFavoriteChanged
                        )
                    },
                    isBookmark: viewModel.isBookmark,
                    onBookmark: { placeId, notifier in
                        viewModel.toggleBookmark(
                            placeId: placeId,
                            userNotifier: notifier,
                            onChange: onBookmarkChanged
                        )
                    },
                    onClose: onClose
                )
            }
        }
        .task {
            await viewModel.load(placeId: place.id)
        }
    }
}
