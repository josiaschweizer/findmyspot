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
    @Binding var selectedPlaceId: UUID?

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

    var body: some View {
        Map(
            initialPosition: .region(Self.initialRegion),
            selection: $selectedPlaceId
        ) {
            ForEach(viewModel.places) { place in
                Annotation(
                    place.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: place.latitude,
                        longitude: place.longitude
                    ),
                    anchor: .center
                ) {
                    PlacePinView(
                        style: PlacePinStyle(
                            isFavorite: place.isFavorite,
                            isBookmark: place.isBookmark
                        ),
                        isSelected: selectedPlaceId == place.id
                    )
                }
                .tag(place.id)
            }
        }
        .mapStyle(.standard)
        .mapControls {
            MapCompass()
            MapScaleView()
        }
    }
}

#Preview {
    PlacesMapView(
        viewModel: PlacesViewModel(),
        selectedPlaceId: .constant(nil)
    )
}
