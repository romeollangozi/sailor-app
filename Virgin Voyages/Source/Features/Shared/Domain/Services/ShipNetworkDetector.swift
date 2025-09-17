//
//  ShipNetworkDetector.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/18/24.
//

import Foundation

protocol ShipNetworkDetectorProtocol {
    func isShipNetworkReachable() async -> Bool
}

class ShipNetworkDetector: ShipNetworkDetectorProtocol {

	private var networkService: NetworkServiceProtocol

	init(networkService: NetworkServiceProtocol = NetworkService.createForShip()) {
		self.networkService = networkService
	}

    func isShipNetworkReachable() async -> Bool {
		let isShipNetworkReachable = await networkService.isShipNetworkReachable()
		return isShipNetworkReachable
    }
}
