//
//  LocationPermisssionManager.swift
//  FindMySpot
//
//  Created by josiaschweizer on 10.10.2026.
//
import Combine
import CoreLocation

@MainActor
final class LocationPermissionManager: ObservableObject {
    private let manager = CLLocationManager()

    func requestIfNeeded() {
        guard manager.authorizationStatus == .notDetermined else {
            return
        }

        manager.requestWhenInUseAuthorization()
    }
}
