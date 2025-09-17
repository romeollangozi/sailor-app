//
//  ShipTimeRepository 2.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/2/25.
//

import VVPersist
import Foundation

protocol ShipTimeRepositoryProtocol {
	func updateShipTime(_ shipTime: ShipTime) async
	func fetchShipTime() async -> Date?
}

class ShipTimeRepository: ShipTimeRepositoryProtocol {

	@MainActor
	func updateShipTime(_ shipTime: ShipTime) async {
		let session = VVDatabase.shared.createSession()
		let shipTimes: [ShipTimeDBModel] = session.fetchAll()
		if let existingShipTime = shipTimes.first {
			existingShipTime.cachedAt = Date()
			existingShipTime.fromUTCDate = shipTime.fromUTCDate
			existingShipTime.fromDateOffset = shipTime.fromDateOffset
		} else {
			let shipTime = ShipTimeDBModel(
				cachedAt: Date(),
				fromUTCDate: shipTime.fromUTCDate,
				fromDateOffset: shipTime.fromDateOffset
			)
			session.insert(shipTime)
		}

		do {
			try session.save()
		} catch {
			print("Failed to save ShipTime: \(error)")
		}
	}

	@MainActor
	func fetchShipTime() async -> Date? {
		let session = VVDatabase.shared.createSession()
		let shipTimes: [ShipTimeDBModel] = session.fetchAll()
		if let existingShipTime = shipTimes.first {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
			formatter.timeZone = TimeZone(secondsFromGMT: 0)

			guard let utcDate = formatter.date(from: existingShipTime.fromUTCDate) else {
				return nil
			}

			// Apply offset to get the initial ship time
			let offsetInSeconds = TimeInterval(existingShipTime.fromDateOffset * 60)
			let initialShipTime = utcDate.addingTimeInterval(offsetInSeconds)

			// Calculate time elapsed since caching
			let timeSinceCached = Date().timeIntervalSince(existingShipTime.cachedAt)

			// Final ship time is initial ship time + time since it was cached
			let currentShipTime = initialShipTime.addingTimeInterval(timeSinceCached)

			return currentShipTime
		} else {
			return nil
		}
	}
}
