//
//  MockGetEateryDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.4.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockGetEateryDetailsUseCase: GetEateryDetailsUseCaseProtocol {
	var result: EateryDetailsModel?
	
	func execute(slug: String, useCache: Bool) async throws -> EateryDetailsModel {
		guard let result = result else {
			throw VVDomainError.genericError
		}
		
		return result
	}
}
