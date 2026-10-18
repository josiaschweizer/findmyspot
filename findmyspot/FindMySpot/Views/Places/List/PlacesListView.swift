//
//  PlacesListView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import CoreLocation
import SwiftUI

struct PlacesListView: View {
    @EnvironmentObject private var interactions: PlaceStore
    @Environment(UserNotifier.self) private var notifier

    let places: [Place]
    let userLocation: CLLocation?
    let sortOrder: PlaceSortOrder
    @Binding var listLayout: PlaceListLayout

    let onSelect: (UUID) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(sortedPlaces) { place in
                    if listLayout == .compact {
                        compactRow(for: place)
                    } else {
                        cardRow(for: place)
                    }
                }
            }
            .padding(AppSpacing.lg)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(AppColors.background)
    }

    private func compactRow(for place: Place) -> some View {
        Button(
            action: {
                onSelect(place.id)
            },
            label: {
                HStack(spacing: AppSpacing.lg) {
                    Image(systemName: AppIcons.places)
                        .font(AppTypography.titleMedium)
                        .foregroundStyle(AppColors.primary)
                        .frame(
                            width: AppLayout.compactThumbnailSize,
                            height: AppLayout.compactThumbnailSize
                        )

                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.xs
                    ) {
                        Text(place.name)
                            .font(AppTypography.titleSmall)
                            .foregroundStyle(AppColors.textPrimary)

                        if let address = place.address,
                            !address.isEmpty
                        {
                            Text(address)
                                .font(AppTypography.caption)
                                .foregroundStyle(
                                    AppColors.textSecondary
                                )
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                    Image(systemName: AppIcons.chevronRight)
                        .foregroundStyle(AppColors.textSecondary)

                }
            }

        )
        .buttonStyle(.plain)
    }

    private func cardRow(for place: Place) -> some View {
        let state = interactions.state(for: place)

        return VStack(spacing: AppSpacing.sm) {
            PlaceCardView(
                place: interactions.applyingState(to: place),
                imageURL: state.imageURL,
                distanceText: distanceText(for: place),
                featureNames: state.featureNames,
                isFavoriteSaving: state.isFavoritesSaving,
                isBookmarkSaving: state.isBookmarksSaving,
                onSelect: {
                    onSelect(place.id)
                },
                onFavorite: {
                    interactions.toggleFavorite(
                        placeId: place.id,
                        userNotifier: notifier
                    )
                },
                onBookmark: {
                    interactions.toggleBookmark(
                        placeId: place.id,
                        userNotifier: notifier
                    )
                }
            )

            if state.isLoadingDetails {
                ProgressView()
                    .tint(AppColors.primary)
                    .accessibilityLabel("Loading places details")
            } else if let message = state.detailsError {
                AppErrorMessage(message: message)

                AppButton("Try again") {
                    Task {
                        await interactions.loadDetails(
                            for: place,
                            force: true
                        )
                    }
                }
            }
        }
        .task(id: place.id) {
            await interactions.loadDetails(for: place)
        }
    }

    private func alphabetical(_ lhs: Place, _ rhs: Place) -> Bool {
        let comparison = lhs.name.localizedStandardCompare(rhs.name)

        if comparison == .orderedSame {
            return lhs.id.uuidString < rhs.id.uuidString
        }

        return comparison == .orderedAscending
    }

    private var sortedPlaces: [Place] {
        switch sortOrder {
        case .nameAscending:
            return places.sorted { alphabetical($0, $1) }
        case .nameDescending:
            return places.sorted { alphabetical($1, $0) }
        case .favoritesFirst:
            return places.sorted { lhs, rhs in
                if lhs.isFavorite != rhs.isFavorite {
                    return lhs.isFavorite
                }

                return alphabetical(lhs, rhs)
            }
        case .nearest:
            guard let userLocation else {
                return places.sorted { alphabetical($0, $1) }
            }

            return
                places
                .map { place in
                    (
                        place: place,
                        distance: userLocation.distance(
                            from: CLLocation(
                                latitude: place.latitude,
                                longitude: place.longitude
                            )
                        )
                    )
                }
                .sorted { lhs, rhs in
                    if lhs.distance == rhs.distance {
                        return alphabetical(lhs.place, rhs.place)
                    }

                    return lhs.distance < rhs.distance
                }
                .map(\.place)
        }
    }

    private func distanceText(for place: Place) -> String? {
        guard let location = userLocation else {
            return nil
        }

        let destination = CLLocation(
            latitude: place.latitude,
            longitude: place.longitude
        )

        let meters = location.distance(from: destination)

        if meters < 1_000 {
            return "\(Int(meters.rounded())) m"
        }

        let kilometers = (meters / 1_000).formatted(
            .number.precision(.fractionLength(2))
        )

        return "\(kilometers) km"
    }
}
