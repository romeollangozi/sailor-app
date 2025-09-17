//
//  LocationService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/19/24.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
	func getLocationAuthorizationStatus() -> LocationAuthorizationStatus
	func requestLocationPermissions() async
}

enum LocationAuthorizationStatus {
	case notDetermined
	case restricted
	case denied
	case authorizedAlways
	case authorizedWhenInUse
}

extension LocationAuthorizationStatus {
	var isAuthorized: Bool {
		switch self {
		case .authorizedAlways, .authorizedWhenInUse:
			return true
		default:
			return false
		}
	}
}

extension LocationAuthorizationStatus {
	init(from authorizationStatus: CLAuthorizationStatus) {
		switch authorizationStatus {
		case .notDetermined:
			self = .notDetermined
		case .restricted:
			self = .restricted
		case .denied:
			self = .denied
		case .authorizedAlways:
			self = .authorizedAlways
		case .authorizedWhenInUse:
			self = .authorizedWhenInUse
		@unknown default:
			self = .notDetermined
		}
	}
}

class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {

    private var permissionContinuation: CheckedContinuation<Void, Never>?
    
    static let shared = LocationService()
    
    private let locationManager = CLLocationManager()

    private override init() {
        super.init()
        locationManager.delegate = self
    }

    func getLocationAuthorizationStatus() -> LocationAuthorizationStatus {
        let clAuthorizationStatus = locationManager.authorizationStatus
		return LocationAuthorizationStatus(from: clAuthorizationStatus)
    }

    func requestLocationPermissions() async {
        await withCheckedContinuation { continuation in
            permissionContinuation = continuation
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        permissionContinuation?.resume()
        permissionContinuation = nil
    }
}
