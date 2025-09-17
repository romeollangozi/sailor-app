//
//  ConnectToShipWiFiUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/3/25.
//


import Foundation

enum ConnectToShipWiFiUseCaseResult {
	case connectedToWiFi
	case failedToConnectToWiFi
	case userDeclined
	case locationPermissionsNotGranted
}

class ConnectToShipWiFiUseCase {

	private let requestLocationPermissionsUseCase: RequestLocationPermissionsUseCase
	private var wiFiConnectionService: WiFiConnectionServiceProtocol

	init(
		requestLocationPermissionsUseCase: RequestLocationPermissionsUseCase = RequestLocationPermissionsUseCase(),
		wiFiConnectionService: WiFiConnectionServiceProtocol = WiFiConnectionService()
	) {
		self.requestLocationPermissionsUseCase = requestLocationPermissionsUseCase
		self.wiFiConnectionService = wiFiConnectionService
	}

	func execute() async -> ConnectToShipWiFiUseCaseResult {
		let permission = await requestLocationPermissionsUseCase.execute()

		if permission.isAuthorized {
			return await connectToWiFi()
		} else {
			return .locationPermissionsNotGranted
		}
	}

	private func connectToWiFi() async -> ConnectToShipWiFiUseCaseResult {
		do {
			try await wiFiConnectionService.connect(ssid: WiFiConstants.SSID)
			return .connectedToWiFi
		} catch WiFiConnectionError.userDenied {
			return .userDeclined
		} catch {
			return .failedToConnectToWiFi
		}
	}
}
