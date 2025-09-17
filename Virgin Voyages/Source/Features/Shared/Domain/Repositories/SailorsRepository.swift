//
//  SailorsRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 19.2.25.
//

protocol SailorsRepositoryProtocol {
	func fetchMySailors(reservationGuestId: String, reservationNumber: String, useCache: Bool, appointmentLinkId: String?) async throws -> [SailorModel]
}

extension SailorsRepositoryProtocol {
	func fetchMySailors(reservationGuestId: String, reservationNumber: String, useCache: Bool) async throws -> [SailorModel] {
		return try await fetchMySailors(reservationGuestId: reservationGuestId, reservationNumber: reservationNumber, useCache: useCache, appointmentLinkId: nil)
	}
}

final class SailorsRepository: SailorsRepositoryProtocol {
	private let networkService: NetworkServiceProtocol
	
	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}
	
	func fetchMySailors(reservationGuestId: String, reservationNumber: String, useCache: Bool, appointmentLinkId: String?) async throws -> [SailorModel] {
		let response = try await networkService.getMySailors(reservationGuestId: reservationGuestId,
															 reservationNumber: reservationNumber,
															 appointmentLinkId: appointmentLinkId,
															 cacheOption: .timedCache(forceReload: !useCache)
		)
		
		return response.map({ $0.toDomain(reservationGuestId: reservationGuestId) })
	}
}
