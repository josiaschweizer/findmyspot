//
//  AddPlaceDetailsStep.swift
//  FindMySpot
//

import MapKit
import SwiftUI

struct AddPlaceDetailsStep: View {
    @Bindable var viewModel: AddPlaceViewModel

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 47.4250,
                longitude: 9.3770
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.012,
                longitudeDelta: 0.012
            )
        )
    )

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: viewModel.latitude,
            longitude: viewModel.longitude
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xl) {
            AddPlaceSectionTitle(
                eyebrow: "02 · DIE DETAILS",
                title: "Ausstattung & Lage"
            )

            AddPlaceChipSection(title: "Aktivitäten") {
                ForEach(PlaceActivity.allCases) { activity in
                    SelectableChip(
                        title: activity.title,
                        isSelected: viewModel.selectedActivities.contains(
                            activity
                        )
                    ) {
                        viewModel.toggle(activity)
                    }
                }
            }

            AddPlaceChipSection(title: "Eigenschaften") {
                ForEach(AddPlaceFeature.allCases) { feature in
                    SelectableChip(
                        title: feature.title,
                        isSelected: viewModel.selectedFeatures.contains(
                            feature
                        )
                    ) {
                        viewModel.toggle(feature)
                    }
                }
            }

            AddPlaceMapPicker(
                cameraPosition: $cameraPosition,
                coordinate: coordinate,
                onSelect: viewModel.updatePosition
            )
        }
    }
}
