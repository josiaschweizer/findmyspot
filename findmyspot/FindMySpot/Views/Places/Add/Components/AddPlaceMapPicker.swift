//
//  AddPlaceMapPicker.swift
//  FindMySpot
//

import MapKit
import SwiftUI

struct AddPlaceMapPicker: View {
    @Binding var cameraPosition: MapCameraPosition

    let coordinate: CLLocationCoordinate2D
    let onSelect: (Double, Double) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Position auf der Karte")
                .font(AppTypography.titleSmall)

            Text("Tippe auf die Karte, um den Pin zu setzen.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.textSecondary)

            MapReader { proxy in
                Map(position: $cameraPosition) {
                    Marker("Neuer Ort", coordinate: coordinate)
                        .tint(AddPlaceStyle.marker)
                }
                .mapStyle(.standard(pointsOfInterest: .excludingAll))
                .onTapGesture { position in
                    guard let coordinate = proxy.convert(
                        position,
                        from: .local
                    ) else {
                        return
                    }

                    onSelect(coordinate.latitude, coordinate.longitude)
                }
            }
            .frame(height: 230)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))

            Text(positionText)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    private var positionText: String {
        let latitude = coordinate.latitude.formatted(
            .number.precision(.fractionLength(4))
        )
        let longitude = coordinate.longitude.formatted(
            .number.precision(.fractionLength(4))
        )
        return "Position: \(latitude), \(longitude)"
    }
}
