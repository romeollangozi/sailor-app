//
//  MyVoyageAddOnsRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 7.3.25.
//


protocol MyVoyageAddOnsRepositoryProtocol {
	func fetchMyVoyageAddOns(reservationNumber: String, shipCode: String, guestId: String, useCache: Bool) async throws -> MyVoyageAddOns?
}

class MyVoyageAddOnsRepository: MyVoyageAddOnsRepositoryProtocol {

	private let networkService: NetworkServiceProtocol

	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}

	func fetchMyVoyageAddOns(reservationNumber: String, shipCode: String, guestId: String, useCache: Bool) async throws -> MyVoyageAddOns? {
		guard let response = try await networkService.getMyVoyageAddOns(reservationNumber: reservationNumber, shipCode: shipCode, guestId: guestId, cacheOption: .timedCache(forceReload: !useCache)) else {
			return nil
		}
		return response.toDomain()
	}
}
