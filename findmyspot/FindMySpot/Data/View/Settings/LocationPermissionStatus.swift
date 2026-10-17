//
//  LocationPersmissionStatus.swift
//  FindMySpot
//
//  Created by josiaschweizer on 16.10.2026.
//

import CoreLocation
import SwiftUI

enum LocationPermissionStatus {
    case notDetermined
    case allowed
    case denied
    case restricted

    init(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways: self = .allowed
        case .denied: self = .denied
        case .restricted: self = .restricted
        case .notDetermined: self = .notDetermined
        @unknown default: self = .notDetermined
        }
    }

    var title: String {
        switch self {
        case .notDetermined: "Not set"
        case .allowed: "Allowed"
        case .denied: "Denied"
        case .restricted: "Restricted"
        }
    }

    var description: String {
        switch self {
        case .notDetermined:
            "FindMySpot only asks for your location when you open the map."
        case .allowed:
            "Your location is only used to show places enar you and is never stored."
        case .denied:
            "You can still search for places, but distances won't be shown."
        case .restricted:
            "Location access is restricted on this device, e.g. by Screen Time."
        }
    }

    var color: Color {
        switch self {
        case .allowed: AppColors.success
        case .denied: AppColors.error
        case .restricted: AppColors.warning
        case .notDetermined: AppColors.textSecondary
        }
    }

    var canOpenSettings: Bool {
        self != .restricted
    }
}
