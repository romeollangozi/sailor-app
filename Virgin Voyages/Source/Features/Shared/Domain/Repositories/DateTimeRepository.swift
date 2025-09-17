//
//  DateTimeRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/30/25.
//

import Foundation

struct DateTime {
	let deviceTime: Date
	let shipTime: Date?

	func getCurrentDateTime() -> Date {
		return shipTime ?? deviceTime
	}
}

protocol DateTimeRepositoryProtocol {
	func fetchDateTime() async -> DateTime
}

final class DateTimeRepository: DateTimeRepositoryProtocol {

	let shipTimeRepository: ShipTimeRepositoryProtocol

	init(shipTimeRepository: ShipTimeRepositoryProtocol = ShipTimeRepository()) {
		self.shipTimeRepository = shipTimeRepository
	}

	func fetchDateTime() async -> DateTime {
		let shipTime = await shipTimeRepository.fetchShipTime()
		return DateTime(deviceTime: Date(), shipTime: shipTime)
	}
}
