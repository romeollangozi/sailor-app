//
//  ValidateEmailUseCaseMock.swift
//  Virgin Voyages
//
//  Created by TX on 1.9.25.
//

import XCTest
@testable import Virgin_Voyages

final class ValidateEmailUseCaseMock: ValidateEmailUseCaseProtocol {
    let repo: SignUpRepositoryMock
    init(repo: SignUpRepositoryMock) { self.repo = repo }

    func execute(email: String, clientToken: String) async throws -> ValidateEmail {
        if let model = try await repo.getValidateEmail(email: email, clientToken: clientToken) {
            return model
        } else {
            // Treat "nil" from repo as "does not exist"
            return ValidateEmail(isEmailExist: false)
        }
    }
}

