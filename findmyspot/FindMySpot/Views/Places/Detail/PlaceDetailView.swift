//
//  PlaceDetailView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import SwiftUI

@MainActor
struct PlaceDetailView: View {
    @Environment(UserNotifier.self) private var userNotifier
    @EnvironmentObject private var interactions: PlaceStore

    let place: Place

    private var state: PlaceStore.State {
        interactions.state(for: place)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                image

                VStack(alignment: .leading, spacing: AppSpacing.xxl) {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text(place.name)
                            .font(AppTypography.titleLarge)
                            .foregroundStyle(AppColors.textPrimary)

                        if let address = formattedAddress {
                            HStack(spacing: AppSpacing.sm) {
                                Image(systemName: "mappin.and.ellipse")
                                Text(address)
                            }
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.textSecondary)
                        }
                    }

                    HStack(spacing: AppSpacing.md) {
                        actionButton(
                            "Favorite",
                            icon: state.isFavorite
                                ? AppIcons.favoriteSelected : AppIcons.favorite,
                            isSelected: state.isFavorite,
                            isEnabled: !state.isFavoritesSaving
                        ) {
                            interactions.toggleFavorite(
                                placeId: place.id,
                                userNotifier: userNotifier
                            )
                        }

                        actionButton(
                            "Save for later",
                            icon: state.isBookmark
                                ? AppIcons.bookmarkSelected : AppIcons.bookmark,
                            isSelected: state.isBookmark,
                            isEnabled: !state.isBookmarksSaving
                        ) {
                            interactions.toggleBookmark(
                                placeId: place.id,
                                userNotifier: userNotifier
                            )
                        }
                    }

                    if !state.featureNames.isEmpty {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            sectionTitle("Amenities")

                            FlowLayout {
                                ForEach(state.featureNames, id: \.self) {
                                    name in
                                    Text(name)
                                        .font(AppTypography.label)
                                        .foregroundStyle(AppColors.textPrimary)
                                        .padding(.horizontal, AppSpacing.md)
                                        .padding(.vertical, AppSpacing.sm2)
                                        .background(
                                            AppColors.surfaceWhite,
                                            in: RoundedRectangle(
                                                cornerRadius: AppRadius.xs
                                            )
                                        )
                                        .overlay {
                                            RoundedRectangle(
                                                cornerRadius: AppRadius.xs
                                            )
                                            .strokeBorder(AppColors.borderDefault)
                                        }
                                }
                            }
                        }
                    }

                    if let description = place.description,
                        !description.isEmpty
                    {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            sectionTitle("About this place")

                            Text(description)
                                .font(AppTypography.body)
                                .foregroundStyle(AppColors.textSecondary)
                                .lineSpacing(AppSpacing.xxs)
                        }
                    }

                    if let message = state.detailsError {
                        AppErrorMessage(message: message)
                    }
                }
                .padding(.horizontal, AppSpacing.xl)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, AppSpacing.xxl)
        }
        .background(AppColors.background)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await interactions.loadDetails(for: place)
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 22, weight: .bold))
            .foregroundStyle(AppColors.textPrimary)
            .accessibilityAddTraits(.isHeader)
    }

    private func actionButton(
        _ title: String,
        icon: String,
        isSelected: Bool,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: icon)
                    .font(AppTypography.titleMedium)
                    .foregroundStyle(
                        isSelected ? AppColors.primary : AppColors.textPrimary
                    )

                Text(title)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: AppLayout.controlHeight)
            .background(
                isSelected ? AppColors.selectedBackground : AppColors.surfaceWhite,
                in: RoundedRectangle(cornerRadius: AppRadius.xl)
            )
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .strokeBorder(
                        isSelected ? AppColors.highliehgt : AppColors.borderDefault
                    )
            }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

    private var image: some View {
        Group {
            if let imageURL = state.imageURL {
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

            if state.isLoadingDetails {
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
