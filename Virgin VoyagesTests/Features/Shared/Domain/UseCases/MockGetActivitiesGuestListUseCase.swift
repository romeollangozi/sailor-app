//
//  MockGetActivitiesGuestListUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

import XCTest

@testable import Virgin_Voyages

final class MockGetActivitiesGuestListUseCase: GetActivitiesGuestListUseCaseProtocol {
	var mockResponse: [ActivitiesGuest] = []
	var shouldThrowError: Bool = false
	
	func execute() async -> Result<[Virgin_Voyages.ActivitiesGuest], Virgin_Voyages.VVDomainError> {
		if shouldThrowError {
			return .failure(.genericError)
		}
		
		return .success(mockResponse)
	}
	
	func executeV2() async throws -> [Virgin_Voyages.ActivitiesGuest] {
		if shouldThrowError {
			throw VVDomainError.genericError
		}
		
		return mockResponse
	}
}
