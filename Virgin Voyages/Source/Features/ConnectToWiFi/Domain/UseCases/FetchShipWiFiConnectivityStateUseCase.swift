//
//  FetchShipWiFiConnectivityStateUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/7/25.
//


class FetchShipWiFiConnectivityStateUseCase {

	private let shipWiFiConnectivityService: ShipWiFiConnectivityServiceProtocol

	init(shipWiFiConnectivityService: ShipWiFiConnectivityServiceProtocol = ShipWiFiConnectivityService.shared) {
		self.shipWiFiConnectivityService = shipWiFiConnectivityService
	}

	func execute() -> ShipWiFiConnectivityConnectionState {
		return self.shipWiFiConnectivityService.state
	}

}
