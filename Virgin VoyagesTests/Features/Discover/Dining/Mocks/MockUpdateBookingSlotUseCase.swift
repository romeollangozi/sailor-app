//
//  MockUpdateBookingSlotUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.6.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockUpdateBookingSlotUseCase: UpdateBookingSlotUseCaseProtocol {
	var isCalled: Bool = false
	var calledInput: UpdateBookingSlotInputModel?
	var mockResponse: UpdateBookingSlotModel?
	var shouldThrowError: Bool = false
	
	func execute(input: Virgin_Voyages.UpdateBookingSlotInputModel) async throws -> Virgin_Voyages.UpdateBookingSlotModel {
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
