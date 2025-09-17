//
//  MockEateriesListRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.3.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockEateriesListRepository: EateriesListRepositoryProtocol {
	func fetchEateries(reservationId: String, reservationGuestId: String, shipCode: String, shipName: String, reservationNumber: String, includePortsName: Bool, useCache: Bool) async throws -> Virgin_Voyages.EateriesList? {
		if shouldThrowError {
			throw VVDomainError.genericError
		}
		return mockEateriesList
	}
	
	var shouldThrowError = false
	var mockEateriesList: EateriesList?
}

