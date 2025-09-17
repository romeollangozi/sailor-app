//
//  MockLoginUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 24.7.25.
//

import Foundation
@testable import Virgin_Voyages

class MockLoginUseCase: LoginUseCaseProtocol {
    var shouldThrow: Bool = false
    var mockResult: LoginResult = .success
    
    func execute(_ type: LoginType) async throws -> LoginResult {
        if shouldThrow {
            throw Endpoint.FieldsValidationError(fieldErrors: [], errors: ["Login failed"])
        }
        return mockResult
    }
}
