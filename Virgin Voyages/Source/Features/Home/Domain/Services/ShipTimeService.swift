//
//  ShipTimeService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/3/25.
//

import Foundation

enum ShipTimeServiceError: VVError {
	case unableToFetchShipTime
}

protocol ShipTimeServiceProtocol {
	func syncShipTime() async
	func fetchShipTime() async -> Date?
}

class ShipTimeService: ShipTimeServiceProtocol {

	private let networkService: NetworkServiceProtocol
	private var shipTimeRepository: ShipTimeRepositoryProtocol
	private var currentSailorManager: CurrentSailorManagerProtocol

	init(
		networkService: NetworkServiceProtocol = NetworkService.createForShip(),
		shipTimeRepository: ShipTimeRepositoryProtocol = ShipTimeRepository(),
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()
	) {
		self.networkService = networkService
		self.shipTimeRepository = shipTimeRepository
		self.currentSailorManager = currentSailorManager
	}

	func syncShipTime() async {
		guard let sailor = currentSailorManager.getCurrentSailor() else {
			return
		}

		guard let shipTime = try? await fetchShipTime(
			shipCode: sailor.shipCode,
			startTime: sailor.startDateTime
		) else {
			return
		}

		await cacheShipTime(shipTime: shipTime)
	}

	func fetchShipTime() async -> Date? {
		return await shipTimeRepository.fetchShipTime()
	}

	private func cacheShipTime(shipTime: ShipTime) async {
		await shipTimeRepository.updateShipTime(shipTime)
	}

	private func fetchShipTime(shipCode: String, startTime: String) async throws -> ShipTime {
		do {
			let response = try await networkService.getShipTime(shipCode: shipCode, startTime: startTime)
			return response.toDomain()
		} catch {
			throw ShipTimeServiceError.unableToFetchShipTime
		}
	}
}
