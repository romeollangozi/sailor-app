//
//  MockBookSlotUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.4.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockBookSlotUseCase: BookSlotUseCaseProtocol {
	var isCalled: Bool = false
	var calledInput: BookSlotInputModel?
	var mockResponse: BookSlot?
	var shouldThrowError: Bool = false
	
	func execute(input: BookSlotInputModel) async throws -> BookSlot {
		isCalled = true
		calledInput = input
		
		if shouldThrowError {
			throw VVDomainError.genericError
		}
		
		guard let response = mockResponse else {
			throw VVDomainError.genericError
		}
		
		return response
	}
}
