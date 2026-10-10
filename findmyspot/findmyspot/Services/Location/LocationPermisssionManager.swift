//
//  LocationPermisssionManager.swift
//  FindMySpot
//
//  Created by josiaschweizer on 10.10.2026.
//
import Combine
import CoreLocation

@MainActor
final class LocationPermissionManager:
    NSObject,
    ObservableObject,
    @preconcurrency CLLocationManagerDelegate
{
    @Published private(set) var location: CLLocation?

    private let manager = CLLocationManager()
    private var isActive = false

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 50
    }

    func requestIfNeeded() {
        isActive = true

        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            updateTracking()
        }
    }

    func stop() {
        isActive = false
        manager.stopUpdatingLocation()
    }

    private func updateTracking() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if isActive {
                manager.startUpdatingLocation()
            }

        case .denied, .restricted:
            manager.stopUpdatingLocation()
            location = nil

        case .notDetermined:
            break

        @unknown default:
            manager.stopUpdatingLocation()
            location = nil
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateTracking()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard isActive,
            let latest = locations.last,
            latest.horizontalAccuracy >= 0,
            abs(latest.timestamp.timeIntervalSinceNow) < 60
        else {
            return
        }

        location = latest
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        location = nil
    }
}
