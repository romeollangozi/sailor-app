//
//  EateriesListRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 23.11.24.
//

import VVPersist

protocol EateriesListRepositoryProtocol {
	func fetchEateries(reservationId: String, reservationGuestId: String, shipCode: String, shipName: String, reservationNumber: String, includePortsName: Bool, useCache: Bool) async throws -> EateriesList?
}

extension EateriesListRepositoryProtocol {
	func fetchEateries(reservationId: String, reservationGuestId: String, shipCode: String, shipName: String, reservationNumber: String, includePortsName: Bool) async throws -> EateriesList? {
		return try await fetchEateries(reservationId: reservationId, reservationGuestId: reservationGuestId, shipCode: shipCode, shipName: shipName, reservationNumber: reservationNumber, includePortsName: includePortsName, useCache: true)
	}
}

final class EateriesListRepository: EateriesListRepositoryProtocol {
	private let networkService: NetworkServiceProtocol
	
	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}
	
	func fetchEateries(reservationId: String, reservationGuestId: String, shipCode: String, shipName: String, reservationNumber: String, includePortsName: Bool, useCache: Bool) async throws -> EateriesList? {
		guard let response = try await self.networkService.getEateriesList(reservationId: reservationId, reservationGuestId: reservationGuestId, shipCode: shipCode, reservationNumber: reservationNumber, includePortsName: true, cacheOption: .timedCache(forceReload: !useCache))
		else { return nil }
		
		return response.toDomain(shipName: shipName)
	}
}

