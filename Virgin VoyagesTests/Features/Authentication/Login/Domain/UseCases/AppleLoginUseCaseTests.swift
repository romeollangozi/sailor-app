//
//  AppleLoginUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 16.9.24.
//


import XCTest
import Foundation
@testable import Virgin_Voyages

class MockAppleLoginService: AppleLoginService {

    var shouldReturnError: Bool = false
    
    // MARK: - Mock Sign in with Apple
    override func requestToken() async -> SocialUser? {
        if shouldReturnError {
            return nil
        }
        return SocialUser(id: "userId", firstName: "Test first name", lastName: "test last name", email: "test@test.com", profileImageUrl: nil)
    }}

class AppleLoginUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    var mockService: MockAppleLoginService!
    var useCase: AppleLoginUseCase!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockService = MockAppleLoginService()
        useCase = AppleLoginUseCase(service: mockService)
    }
    
    // MARK: - Tear Down
    override func tearDown() {
        mockService = nil
        useCase = nil
        super.tearDown()
    }
    
    // MARK: - Test Success Scenario
    func testExecute_whenServiceReturnsSuccess_shouldReturnSocialUser() async {
        // Arrange
        mockService.shouldReturnError = false
        
        // Act
        let result = await useCase.execute()
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, "userId")
        XCTAssertEqual(result?.firstName, "Test first name")
        XCTAssertEqual(result?.lastName, "test last name")
        XCTAssertEqual(result?.email, "test@test.com")
    }
    
    // MARK: - Test Failure Scenario
    func testExecute_whenServiceReturnsError_shouldReturnNil() async {
        // Arrange
        mockService.shouldReturnError = true
        
        // Act
        let result = await useCase.execute()
        
        // Assert
        XCTAssertNil(result)
    }
}
