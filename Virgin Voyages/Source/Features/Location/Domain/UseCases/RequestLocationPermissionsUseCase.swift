//
//  RequestLocationPermissionsUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/19/24.
//

import Foundation

class RequestLocationPermissionsUseCase {
	private let locationService: LocationServiceProtocol

    init(locationService: LocationServiceProtocol = LocationService.shared) {
		self.locationService = locationService
	}

	func execute() async -> LocationAuthorizationStatus {
		let authorizationStatus = locationService.getLocationAuthorizationStatus()
		switch authorizationStatus {
		case .notDetermined:
			await requestLocationPermissions()
			return locationService.getLocationAuthorizationStatus()
		case .restricted, .denied, .authorizedAlways, .authorizedWhenInUse:
			return authorizationStatus
		}
	}

	private func requestLocationPermissions() async {
		await locationService.requestLocationPermissions()
	}
}
