//
//  MockCancelBookingSlotUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.6.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockCancelBookingSlotUseCase: CancelBookingSlotUseCaseProtocol {
	var isCalled: Bool = false
	var calledInput: CancelBookingSlotInputModel?
	var mockResponse: CancelBookingSlotModel?
	var shouldThrowError: Bool = false
	
	func execute(input: Virgin_Voyages.CancelBookingSlotInputModel) async throws -> Virgin_Voyages.CancelBookingSlotModel {
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
