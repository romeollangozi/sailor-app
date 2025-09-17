//
//  MockSetPinRepository.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 23.7.25.
//

import Foundation
@testable import Virgin_Voyages

class MockSetPinRepository: SetPinRepositoryProtocol {

	var setPinCalled = false
	var setPinInput: SetPinInput?
	var mockResponse: EmptyModel?
	var shouldThrowError = false
	var errorToThrow: Error?

	init(mockResponse: EmptyModel? = EmptyModel(), shouldThrowError: Bool = false, errorToThrow: Error? = nil) {
		self.mockResponse = mockResponse
		self.shouldThrowError = shouldThrowError
		self.errorToThrow = errorToThrow
	}

	func setPin(input: SetPinInput) async throws -> EmptyModel? {
		setPinCalled = true
		setPinInput = input

		if shouldThrowError {
			throw errorToThrow ?? VVDomainError.genericError
		}

		return mockResponse
	}
}
