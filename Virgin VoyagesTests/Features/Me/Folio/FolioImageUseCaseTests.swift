//
//  FolioImageUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 10.7.25.
//

import XCTest
@testable import Virgin_Voyages

final class FolioImageUseCaseTests: XCTestCase {
    private var mockTokenManager: MockTokenManager!
    private var useCase: FolioImageUseCase!
    
    override func setUp() {
        super.setUp()
        mockTokenManager = MockTokenManager()
        useCase = FolioImageUseCase(tokenManager: mockTokenManager)
    }
    
    override func tearDown() {
        mockTokenManager = nil
        useCase = nil
        super.tearDown()
    }
    
    func testAuthenticatedImageURL_appendsAccessToken() {
        let mockToken = Token(refreshToken: "", tokenType: "", accessToken: "abc123", expiresIn: 0, status: .active)
        mockTokenManager.tokenResult = mockToken
        
        let baseURL = "https://example.com/image.jpg"
        
        let result = useCase.authenticatedImageURL(from: baseURL)
        
        XCTAssertEqual(result?.absoluteString, "https://example.com/image.jpg?access_token=abc123")
    }
    
    func testAuthenticatedImageURL_returnsNil_whenTokenIsNil() {
        mockTokenManager.tokenResult = nil
        let baseURL = "https://example.com/image.jpg"

        let result = useCase.authenticatedImageURL(from: baseURL)

        XCTAssertNil(result)
    }
    
    func testAuthenticatedImageURL_returnsNil_whenURLIsInvalid() {
        let mockToken = Token(refreshToken: "", tokenType: "", accessToken: "abc123", expiresIn: 0, status: .active)
        mockTokenManager.tokenResult = mockToken
        let baseURL = "ht!tp:// example .com/<>image.jpg"

        let result = useCase.authenticatedImageURL(from: baseURL)

        XCTAssertNil(result)
    }
}
