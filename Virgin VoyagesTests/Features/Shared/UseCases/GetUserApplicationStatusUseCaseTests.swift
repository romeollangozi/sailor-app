//
//  GetUserApplicationStatusUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 21.11.24.
//

import XCTest
@testable import Virgin_Voyages

final class GetUserApplicationStatusUseCaseTests: XCTestCase {
    private var useCase: GetUserApplicationStatusUseCaseProtocol!
	private var mockSailorsProfileRepository: SailorProfileV2RepositoryMock!
	private var mockTokenManager: MockTokenManager!
    
    override func setUp() {
        super.setUp()
		mockSailorsProfileRepository = SailorProfileV2RepositoryMock()
        mockTokenManager = MockTokenManager()
        useCase = GetUserApplicationStatusUseCase(
			sailorsProfileRepository: mockSailorsProfileRepository,
            tokenManager: mockTokenManager
        )
    }
    
    override func tearDown() {
        useCase = nil
		mockSailorsProfileRepository = nil
        mockTokenManager = nil
        super.tearDown()
    }
    
    func testExecuteReturnsLoggedOutStatusWhenTokenIsNotPresent() async throws {
        mockTokenManager.token = nil
        
        let status = try await useCase.execute()
        
        XCTAssertEqual(status, .userLoggedOut)
    }
    
    func testExecuteReturnsLoggedInWithReservationWhenReservationExists() async throws {
        mockTokenManager.token = Token(refreshToken: "refreshToken", tokenType: "tokenType", accessToken: "accessToken", expiresIn: 12335, status: .active)
		mockSailorsProfileRepository.mockSailorProfile = .sample()

        let status = try await useCase.execute()
        
        XCTAssertEqual(status, .userLoggedInWithReservation)
    }
    
    func testExecuteReturnsUserLoggedInWithoutReservationWhenReservationDoesNotExists() async throws {
        mockTokenManager.token = Token(refreshToken: "refreshToken", tokenType: "tokenType", accessToken: "accessToken", expiresIn: 12335, status: .active)
		mockSailorsProfileRepository.mockSailorProfile = nil
    
        let status = try await useCase.execute()
        
        XCTAssertEqual(status, .userLoggedInWithoutReservation)
    }
}
