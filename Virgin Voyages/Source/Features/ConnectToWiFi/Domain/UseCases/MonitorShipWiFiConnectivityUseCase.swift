//
//  MonitorShipWiFiConnectivityUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/28/25.
//

import Foundation

class MonitorShipWiFiConnectivityUseCase: ShipWiFiConnectivityServiceObserver {
	
	private var onUpdate: VoidCallback?
	private let shipWiFiConnectivityService: ShipWiFiConnectivityServiceProtocol

	init(shipWiFiConnectivityService: ShipWiFiConnectivityServiceProtocol = ShipWiFiConnectivityService.shared) {
		self.shipWiFiConnectivityService = shipWiFiConnectivityService
		self.shipWiFiConnectivityService.addObserver(self)
	}

	deinit {
		self.shipWiFiConnectivityService.removeObserver(self)
	}

	func execute(onUpdate: VoidCallback? = nil) async {
		self.onUpdate = onUpdate
		await shipWiFiConnectivityService.checkConnection()
	}

	func connectivityDidUpdate() {
		Task {
			await notifyConnectivityUpdate()
		}
	}

	@MainActor
	private func notifyConnectivityUpdate() {
		self.onUpdate?()
	}
}
