//
//  DashboardView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import CoreLocation
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var interactions: PlaceStore
    @Environment(UserNotifier.self) private var notifier

    @StateObject private var viewModel = DashboardViewModel()
    @StateObject private var locationPermission = LocationPermissionManager()

    private var displayedPlaces: [Place] {
        viewModel.places
            .map { interactions.applyingState(to: $0) }
            .sorted {
                let comparison = $0.name.localizedStandardCompare($1.name)

                if comparison == .orderedSame {
                    return $0.id.uuidString < $1.id.uuidString
                }

                return comparison == .orderedAscending
            }
    }

    private var favorites: [Place] {
        displayedPlaces.filter(\.isFavorite)
    }

    private var bookmarks: [Place] {
        displayedPlaces.filter(\.isBookmark)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xxxl) {
                header

                if viewModel.isLoading {
                    ProgressView("Loading saved places...")
                        .tint(AppColors.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.xxxl)
                } else if let message = viewModel.errorMessage {
                    AppCard {
                        VStack(spacing: AppSpacing.lg) {
                            AppErrorMessage(message: message)

                            AppButton("Try again") {
                                Task {
                                    await reload()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    section(
                        title: "Favorites",
                        subtitle: "Your favorite places",
                        icon: AppIcons.favorite,
                        emptyTitle: "No favorites yet",
                        emptyMessage: "Mark a place with a heart",
                        places: favorites
                    )

                    section(
                        title: "Bookmarks",
                        subtitle: "Places saved for another time",
                        icon: AppIcons.bookmark,
                        emptyTitle: "No bookmarks yet",
                        emptyMessage: "Mark a place with a bookmark",
                        places: bookmarks
                    )

                }
            }
            .padding(AppSpacing.xxl)
        }
        .background(AppColors.background)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await reload()
        }
        .refreshable {
            await reload()
        }
        .onAppear {
            locationPermission.requestIfNeeded()
        }
        .onDisappear {
            locationPermission.stop()
        }
    }

    private var header: some View {
        HStack {
            Text("Hello")
                .font(AppTypography.titleLarge)
                .foregroundStyle(AppColors.textPrimary)

            Spacer()

            Image(systemName: AppIcons.person)
                .font(AppTypography.titleMedium)
                .foregroundStyle(AppColors.primary)
                .frame(
                    width: AppLayout.minimumControlHeight,
                    height: AppLayout.minimumControlHeight
                )
                .background(AppColors.surfaceSecondary, in: Circle())
                .overlay {
                    Circle().strokeBorder(AppColors.borderDefault)
                }
                .accessibilityHidden(true)
        }
        .padding(.top, AppSpacing.lg)
    }

    private func section(
        title: String,
        subtitle: String,
        icon: String,
        emptyTitle: String,
        emptyMessage: String,
        places: [Place]
    ) -> some View {
        LazyVStack(alignment: .leading, spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                HStack {
                    Text(title)
                        .font(AppTypography.titleMedium)
                        .foregroundStyle(AppColors.textPrimary)

                    Spacer()

                    Text("\(places.count)")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.textSecondary)
                }

                Text(subtitle)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(.bottom, AppSpacing.sm)

            if places.isEmpty {
                AppEmptyState(
                    icon: icon,
                    title: emptyTitle,
                    message: emptyMessage
                )
            }

            ForEach(places) { place in
                card(for: place)
            }
        }
    }

    private func card(for place: Place) -> some View {
        let details = viewModel.details[place.id]
        let state = interactions.state(for: place)

        return PlaceCardView(
            place: place,
            imageURL: details?.imageURL,
            distanceText: distanceText(for: place),
            featureNames: details?.featureNames ?? [],
            isFavoriteSaving: state.isFavoritesSaving,
            isBookmarkSaving: state.isBookmarksSaving,
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
        .task(id: place.id) {
            await viewModel.loadDetails(for: place.id)
        }
    }

    private func reload() async {
        await viewModel.load()

        guard !Task.isCancelled else {
            return
        }

        interactions.register(viewModel.places)
    }

    private func distanceText(for place: Place) -> String? {
        guard let location = locationPermission.location else {
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

#Preview {
    NavigationStack {
        DashboardView()
    }
}
