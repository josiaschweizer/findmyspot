import CoreLocation
//
//  PlacesListView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//
import SwiftUI

struct PlacesListView: View {
    let places: [Place]
    let userLocation: CLLocation?
    let sortOrder: PlaceSortOrder
    let onSelect: (UUID) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(sortedPlaces) { place in
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
            }
            .padding(AppSpacing.lg)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(AppColors.background)
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
}
