//
//  PlaceDetailView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import SwiftUI

@MainActor
struct PlaceDetailView: View {
    let place: Place

    @StateObject private var viewModel = PlacePreviewViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                image

                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    Text(place.name)
                        .font(AppTypography.titleLarge)
                        .foregroundStyle(AppColors.textPrimary)

                    if let address = formattedAddress {
                        Text(address)
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }

                    if !viewModel.featureNames.isEmpty {
                        FlowLayout {
                            ForEach(viewModel.featureNames, id: \.self) { name in
                                AppTag(name)
                            }
                        }
                    }

                    if let description = place.description,
                        !description.isEmpty
                    {
                        Text(description)
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, AppSpacing.xxl)
        }
        .background(AppColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load(placeId: place.id)
        }
    }

    private var image: some View {
        Group {
            if let imageURL = viewModel.imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty, .failure:
                        imagePlaceholder

                    @unknown default:
                        imagePlaceholder
                    }
                }
            } else {
                imagePlaceholder
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 260)
        .clipped()
        .accessibilityHidden(true)
    }

    private var imagePlaceholder: some View {
        ZStack {
            AppColors.surfaceSecondary

            if viewModel.isLoading {
                ProgressView()
                    .tint(AppColors.primary)
            } else {
                Image(systemName: AppIcons.places)
                    .font(AppTypography.titleLarge)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    private var formattedAddress: String? {
        let parts = [place.address, place.postalCode, place.city]
            .compactMap { $0 }
            .filter { !$0.isEmpty }

        return parts.isEmpty ? nil : parts.joined(separator: " ")
    }
}
