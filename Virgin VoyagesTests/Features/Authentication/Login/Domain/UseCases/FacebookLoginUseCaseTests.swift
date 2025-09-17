//
//  FacebookLoginUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 20.9.24.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

class FacebookLoginUseCaseTests: XCTestCase {
    
    // Mock Service
    class MockFacebookLoginService: FacebookLoginServiceProtocol {
        var shouldThrowError = false
        var socialUser: SocialUser?
        
        func loginWithFacebookAsync() async throws -> SocialUser? {
            if shouldThrowError {
                throw NSError(domain: "LoginError", code: -1, userInfo: nil)
            }
            return socialUser
        }
    }
    
    // Test for successful login
    func testExecute_Success() async throws {
        // Arrange
        let mockService = MockFacebookLoginService()
        let expectedUser = SocialUser(id: "userId", firstName: "Test first name", lastName: "test last name", email: "test@test.com", profileImageUrl: nil)
        mockService.socialUser = expectedUser
        let useCase = FacebookLoginUseCase(authService: mockService)
        
        let user = try await useCase.execute()
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.id, expectedUser.id)
        XCTAssertEqual(user?.firstName, expectedUser.firstName)
        XCTAssertEqual(user?.lastName, expectedUser.lastName)
        XCTAssertEqual(user?.email, expectedUser.email)
    }
    
    // Test for failed login
    func testExecute_Failure() async {
        // Arrange
        let mockService = MockFacebookLoginService()
        mockService.shouldThrowError = true
        let useCase = FacebookLoginUseCase(authService: mockService)
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
