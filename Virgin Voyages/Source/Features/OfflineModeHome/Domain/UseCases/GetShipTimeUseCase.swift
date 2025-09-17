//
//  GetShipTimeUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/2/25.
//

import Foundation

protocol GetShipTimeUseCaseProtocol {
	func execute() async -> Date?
}

class GetShipTimeUseCase: GetShipTimeUseCaseProtocol {
	private var shipTimeService: ShipTimeServiceProtocol

	init(shipTimeService: ShipTimeServiceProtocol = ShipTimeService()) {
		self.shipTimeService = shipTimeService
	}

	func execute() async -> Date? {
		return await shipTimeService.fetchShipTime()
	}
}
