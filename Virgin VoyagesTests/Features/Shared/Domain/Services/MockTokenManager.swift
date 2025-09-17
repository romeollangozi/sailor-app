//
//  MockTokenManager.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 21.11.24.
//

@testable import Virgin_Voyages

class MockTokenManager: TokenManagerProtocol {
    var tokenResult: Virgin_Voyages.Token?
    
    var token: Token? {
        get {
            return tokenResult
        }
        set {
            tokenResult = newValue
        }
    }
}
