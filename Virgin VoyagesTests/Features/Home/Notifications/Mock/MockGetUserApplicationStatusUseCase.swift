//
//  MockGetUserApplicationStatusUseCase.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 11.7.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockGetUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol {
    var result: UserApplicationStatus?
    var shouldThrowError: Bool = false
    var errorToThrow: Error = VVDomainError.genericError
    var executeCallCount: Int = 0
    
    func execute() async throws -> UserApplicationStatus {
        executeCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        if let result = result {
            return result
        }
        
        // Default to userLoggedOut if no result is set
        return .userLoggedOut
    }
}
