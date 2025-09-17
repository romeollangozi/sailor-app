//
//  MockSetPinUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 23.7.25.
//


import Foundation
@testable import Virgin_Voyages

class MockSetPinUseCase: SetPinUseCaseProtocol {
    
    var executeCalled = false
    var executePin: String?
    var mockResponse: EmptyModel?
    var shouldThrowError = false
    var errorToThrow: Error?
    
    init(mockResponse: EmptyModel? = EmptyModel(), shouldThrowError: Bool = false, errorToThrow: Error? = nil) {
        self.mockResponse = mockResponse
        self.shouldThrowError = shouldThrowError
        self.errorToThrow = errorToThrow
    }
    
    func execute(pin: String) async throws -> EmptyModel? {
        executeCalled = true
        executePin = pin
        
        if shouldThrowError {
            throw errorToThrow ?? VVDomainError.genericError
        }
        
        return mockResponse
    }
}
