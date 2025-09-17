//
//  MockBiometricAuthenticationService.swift
//  Virgin VoyagesTests
//
//  Created by Abel Duarte on 8/27/24.
//

import Foundation
@testable import Virgin_Voyages

class MockBiometricAuthenticationService: BiometricAuthenticationService {
    var isBiometricAvailable = true
    var shouldAuthenticateSucceed = true
    
    func isBiometricAuthenticationAvailable() -> Bool {
        return isBiometricAvailable
    }
    
    func authenticateWithBiometrics() async -> Bool {
        return shouldAuthenticateSucceed
    }
}

