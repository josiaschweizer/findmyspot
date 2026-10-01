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
    @ObservedObject var viewModel: PlacesViewModel

    @State private var selectedPlaceID: UUID?

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

    private var selectedPlace: Place? {
        viewModel.places.first { $0.id == selectedPlaceID }
    }

    var body: some View {
        Map(
            initialPosition: .region(Self.initialRegion),
            selection: $selectedPlaceID
        ) {
            ForEach(viewModel.places) { place in
                Marker(
                    place.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: place.latitude,
                        longitude: place.longitude
                    )
                )
                .tag(place.id)

            }
        }
        .mapStyle(.standard)
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .safeAreaInset(edge: .bottom) {
            if let place = selectedPlace {
                PlacePreviewContainer(
                    place: place,
                    onClose: {
                        selectedPlaceID = nil
                    }
                )
                .id(place.id)
                .padding(AppSpacing.lg)
            }
        }
        .task {
            await viewModel.loadIfNeeded()
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
    PlacesMapView(viewModel: PlacesViewModel(fetchPlaces: { [] }))
}
