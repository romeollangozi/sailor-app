//
//  SignUpRepositoryMock.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 5/5/25.
//

import Foundation

import XCTest
@testable import Virgin_Voyages

final class SignUpRepositoryMock: SignUpRepositoryProtocol {
    var shouldThrowError = false
    var mockValidateEmail: ValidateEmail? = ValidateEmail.sample()
    
    func getValidateEmail(email: String, clientToken: String) async throws -> ValidateEmail? {
        
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return mockValidateEmail
    }
    
}
