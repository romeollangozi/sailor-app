//
//  CheckInStatusRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/6/25.
//

import Foundation

struct CheckInStatus {
	var isGuestCheckedIn: Bool
	var isGuestOnBoard: Bool
	var reservationGuestID: String
}

protocol CheckInStatusRepositoryProtocol {
	func fetchCheckInStatus(reservationNumber: String, reservationGuestID: String) async throws -> CheckInStatus
}

class CheckInStatusRepository: CheckInStatusRepositoryProtocol {
	var networkService: NetworkServiceProtocol

	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}

	func fetchCheckInStatus(reservationNumber: String, reservationGuestID: String) async throws -> CheckInStatus {
		let response = try await networkService.fetchCheckInStatus(reservationNumber: reservationNumber,
																   reservationGuestID: reservationGuestID)
		return response.toDomain()
	}
}
