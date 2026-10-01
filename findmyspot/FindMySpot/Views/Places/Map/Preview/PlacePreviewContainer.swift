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
                                        await viewModel.load(placeID: place.id)
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
                    onClose: onClose
                )
            }
        }
        .task {
            await viewModel.load(placeID: place.id)
        }
    }
}
