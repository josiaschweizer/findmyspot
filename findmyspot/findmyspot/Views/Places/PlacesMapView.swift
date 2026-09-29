//
//  PlacesMapView.swift
//  FindMySpot
//
//  Created by josiaschweizer on 06.09.2026.
//

import MapKit
import SwiftUI

@MainActor
struct PlacesMapView: View {
    @StateObject private var viewModel: PlacesViewModel

    private static let initialRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 47.4245,
            longitude: 9.3767
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.045,
            longitudeDelta: 0.045
        )
    )

    init(
        fetchPlaces: @escaping @MainActor () async throws -> [Place]
    ) {
        _viewModel = StateObject(
            wrappedValue: PlacesViewModel(
                fetchPlaces: fetchPlaces
            )
        )
    }

    var body: some View {
        Map(initialPosition: .region(Self.initialRegion)) {
            ForEach(viewModel.places) { place in
                Marker(
                    place.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: place.latitude,
                        longitude: place.longitude
                    )
                )
            }
        }
        .mapStyle(.standard)
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .overlay(alignment: .top) {
            statusOverlay
                .padding(AppSpacing.lg)
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    @ViewBuilder
    private var statusOverlay: some View {
        if viewModel.isLoading {
            loadingCard
        } else if let message = viewModel.errorMessage {
            errorCard(message: message)
        } else if viewModel.places.isEmpty {
            emptyCard
        }
    }

    private var loadingCard: some View {
        AppCard {
            HStack(spacing: AppSpacing.sm2) {
                ProgressView()
                    .tint(AppColors.primary)

                Text("Loading places...")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.textPrimary)
            }
        }
    }

    private func errorCard(message: String) -> some View {
        AppCard {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.lg
            ) {
                AppErrorMessage(message: message)

                AppButton("Try again") {
                    Task {
                        await viewModel.loadPlaces()
                    }
                }
            }
        }
    }

    private var emptyCard: some View {
        AppCard {
            Text("No locations available yet.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)
        }
    }
}

#Preview {
    PlacesMapView(fetchPlaces: { [] })
}
