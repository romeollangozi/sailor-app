//
//  SyncShipTimeUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/31/25.
//

import VVPersist
import Foundation

protocol SyncShipTimeUseCaseProtocol {
	func execute() async
}

class SyncShipTimeUseCase: SyncShipTimeUseCaseProtocol {

	private var shipTimeService: ShipTimeServiceProtocol

	init(
		shipTimeService: ShipTimeServiceProtocol = ShipTimeService()
	) {
		self.shipTimeService = shipTimeService
	}

	func execute() async {
		await shipTimeService.syncShipTime()
	}
}
