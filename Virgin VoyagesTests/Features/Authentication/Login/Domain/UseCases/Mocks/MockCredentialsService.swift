//
//  MockCredentialsService.swift
//  Virgin VoyagesTests
//
//  Created by Abel Duarte on 8/27/24.
//

import Foundation
@testable import Virgin_Voyages

class MockCredentialsService: CredentialsServiceProtocol {
    var savedCredentials: (email: String, password: String)?
    var deletedEmail: String?

    func saveCredentials(email: String, password: String) {
        savedCredentials = (email, password)
    }

    func retrieveCredentials() -> (email: String, password: String)? {
        return savedCredentials
    }

    func deleteCredentials(email: String) {
        deletedEmail = email
    }
}
