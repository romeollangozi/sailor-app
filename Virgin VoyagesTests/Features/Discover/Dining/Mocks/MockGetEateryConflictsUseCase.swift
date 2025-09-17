//
//  MockGetEateryConflictsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.4.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockGetEateryConflictsUseCase: GetEateryConflictsUseCaseProtocol {
	var mockResponse: EateryConflictsModel?
	
	func execute(input: EateryConflictsInputModel) async throws -> EateryConflictsModel {
		guard let response = mockResponse else { throw VVDomainError.genericError }
		
		return response
	}
}
