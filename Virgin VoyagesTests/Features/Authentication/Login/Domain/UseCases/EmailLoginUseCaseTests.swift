//
//  EmailLoginUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Abel Duarte on 8/27/24.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

final class EmailLoginUseCaseTests: XCTestCase {
    
    func testExecuteSuccessfulLoginSavesCredentials() async {
        // Given
        let mockCredentialsService = MockCredentialsService()
        let mockAuthenticationService = MockAuthenticationService()
        let useCase = EmailLoginUseCase(credentialsService: mockCredentialsService, authenticationService: mockAuthenticationService)
        
        // When
        do {
            _ = try await useCase.execute(email: "test@example.com", password: "password123")
        } catch {
            XCTFail("No error expected")
        }
        
        // Then
        XCTAssertEqual(mockCredentialsService.savedCredentials?.email, "test@example.com")
        XCTAssertEqual(mockCredentialsService.savedCredentials?.password, "password123")
        XCTAssertNil(mockCredentialsService.deletedEmail)
    }
    
    func testExecuteFailedLoginDeletesCredentials() async {
        // Given
        let mockCredentialsService = MockCredentialsService()
        let mockAuthenticationService = MockAuthenticationService()
        let useCase = EmailLoginUseCase(credentialsService: mockCredentialsService, authenticationService: mockAuthenticationService)
        
        // When
        do {
            _ = try await useCase.execute(email: "test@example.com", password: "password123")
        } catch {
            XCTFail("No error expected")
        }
        
        // Then
        XCTAssertEqual(mockCredentialsService.deletedEmail, "test@example.com")
        XCTAssertNil(mockCredentialsService.savedCredentials)
    }
    
    func testExecuteSuccessfulLoginReplacesExistingCredentials() async {
        // Given
        let mockCredentialsService = MockCredentialsService()
        let mockAuthenticationService = MockAuthenticationService()
        mockCredentialsService.saveCredentials(email: "old@example.com", password: "oldpassword")
        let useCase = EmailLoginUseCase(credentialsService: mockCredentialsService, authenticationService: mockAuthenticationService)
        
        // When
        do {
            _ = try await useCase.execute(email: "new@example.com", password: "newpassword")
        } catch {
            XCTFail("No error expected")
        }
        
        // Then
        XCTAssertEqual(mockCredentialsService.savedCredentials?.email, "new@example.com")
        XCTAssertEqual(mockCredentialsService.savedCredentials?.password, "newpassword")
        XCTAssertNil(mockCredentialsService.deletedEmail)
    }
}
