//
//  MockTokenRepository.swift
//  Virgin Voyages
//
//  Created by TX on 24.7.25.
//

import Foundation
@testable import Virgin_Voyages

class MockTokenRepository: TokenRepositoryProtocol {
    
    var token: Token? = nil
    private(set) var didStore = false
    private(set) var didDelete = false
        
    func storeToken(_ token: Token) {
        self.token = token
        didStore = true
    }

    func getToken() -> Token? {
        self.token
    }

    func deleteToken() {
        self.didDelete = true
        self.token = nil
    }
}
