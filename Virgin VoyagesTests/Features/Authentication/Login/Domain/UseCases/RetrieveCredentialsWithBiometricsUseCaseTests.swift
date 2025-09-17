//
//  RetrieveCredentialsWithBiometricsUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Abel Duarte on 8/27/24.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

final class RetrieveCredentialsWithBiometricsUseCaseTests: XCTestCase {

    func testExecuteBiometricUnavailableReturnsBiometricUnavailableError() async {
        // Given
        let mockCredentialsService = MockCredentialsService()
        let mockBiometricService = MockBiometricAuthenticationService()
        mockBiometricService.isBiometricAvailable = false
        let useCase = RetrieveCredentialsWithBiometricsUseCase(credentialsService: mockCredentialsService, biometricsAuthenticationService: mockBiometricService)

        // When
        let result = await useCase.execute()

        // Then
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .biometricUnavailable)
        default:
            XCTFail("Expected failure with .biometricUnavailable, got \(result) instead")
        }
    }

    func testExecuteCredentialsNotFoundReturnsCredentialsNotFoundError() async {
        // Given
        let mockCredentialsService = MockCredentialsService()
        let mockBiometricService = MockBiometricAuthenticationService()
        let useCase = RetrieveCredentialsWithBiometricsUseCase(credentialsService: mockCredentialsService, biometricsAuthenticationService: mockBiometricService)

        // When
        let result = await useCase.execute()

        // Then
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .credentialsNotFound)
        default:
            XCTFail("Expected failure with .credentialsNotFound, got \(result) instead")
        }
    }

    func testExecuteBiometricAuthenticationFailedReturnsBiometricAuthenticationFailedError() async {
        // Given
        let mockCredentialsService = MockCredentialsService()
        mockCredentialsService.saveCredentials(email: "test@example.com", password: "password123")
        let mockBiometricService = MockBiometricAuthenticationService()
        mockBiometricService.shouldAuthenticateSucceed = false
        let useCase = RetrieveCredentialsWithBiometricsUseCase(credentialsService: mockCredentialsService, biometricsAuthenticationService: mockBiometricService)

        // When
        let result = await useCase.execute()

        // Then
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .biometricAuthenticationFailed)
        default:
            XCTFail("Expected failure with .biometricAuthenticationFailed, got \(result) instead")
        }
    }

    func testExecuteSuccessfulAuthenticationReturnsCredentials() async {
        // Given
        let mockCredentialsService = MockCredentialsService()
        mockCredentialsService.saveCredentials(email: "test@example.com", password: "password123")
        let mockBiometricService = MockBiometricAuthenticationService()
        let useCase = RetrieveCredentialsWithBiometricsUseCase(credentialsService: mockCredentialsService, biometricsAuthenticationService: mockBiometricService)

        // When
        let result = await useCase.execute()

        // Then
        switch result {
        case .success(let credentials):
            XCTAssertEqual(credentials.email, "test@example.com")
            XCTAssertEqual(credentials.password, "password123")
        default:
            XCTFail("Expected success with credentials, got \(result) instead")
        }
    }
}
