//
//  MockSwapBookingSlotUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.4.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockSwapBookingSlotUseCase: SwapBookingSlotUseCaseProtocol {
	var isCalled: Bool = false
	var calledInput: SwapBookingSlotInputModel?
	var mockResponse: SwapBookingSlotModel?
	var shouldThrowError: Bool = false
	
	func execute(input: SwapBookingSlotInputModel) async throws -> SwapBookingSlotModel {
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
