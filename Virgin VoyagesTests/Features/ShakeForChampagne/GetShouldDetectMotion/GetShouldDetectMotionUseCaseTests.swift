//
//  GetShouldDetectMotionUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 6/27/25.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

final class GetShouldDetectMotionUseCaseTests: XCTestCase {
    
    var mockAuthenticationService: MockAuthenticationService!
    var mockGetUserShoresideOrShipsideLocationUseCase: MockGetUserShoresideOrShipsideLocationUseCase!
    var mockMusterModeRepository: MockMusterModeStatusRepository!
    var sut: GetShouldDetectMotionUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockAuthenticationService = MockAuthenticationService()
        mockGetUserShoresideOrShipsideLocationUseCase = MockGetUserShoresideOrShipsideLocationUseCase()
        mockMusterModeRepository = MockMusterModeStatusRepository(musterDrillMode: .none)
        
        let musterModeUseCase = MusterModeStatusUseCase(repository: mockMusterModeRepository)
        sut = GetShouldDetectMotionUseCase(authenticationService: mockAuthenticationService, getUserShoresideOrShipsideLocationUseCase: mockGetUserShoresideOrShipsideLocationUseCase, musterModeStatusUseCase: musterModeUseCase)
    }
    
    override func tearDown() {
        mockAuthenticationService = nil
        mockGetUserShoresideOrShipsideLocationUseCase = nil
        mockMusterModeRepository = nil
        sut = nil
        
        super.tearDown()
    }
    
    func test_execute_whenUserIsLoggedInAndOnShip_shouldReturnTrue() {
        // Given
        mockGetUserShoresideOrShipsideLocationUseCase.mockSailorLocation = .ship
        
        // When
        let result = sut.execute()
        
        // Then
        XCTAssertTrue(result, "Should return true when user is logged in and on ship")
    }

    func test_execute_whenUserIsLoggedInAndOnShore_shouldReturnFalse() {
        // Given
        mockGetUserShoresideOrShipsideLocationUseCase.mockSailorLocation = .shore
        
        // When
        let result = sut.execute()
        
        // Then
        XCTAssertFalse(result, "Should return false when user is logged in but on shore")
    }

    func testWhenMusterModeIsEnabled() {
        mockGetUserShoresideOrShipsideLocationUseCase.mockSailorLocation = .ship
        mockMusterModeRepository.musterDrillMode = .important

        // When
        let result = sut.execute()

        // Then
        XCTAssertFalse(result, "Should return false when user is logged is on ship, but muster mode is enabled")
    }

    func testWhenMusterModeIsDisabled() {
        mockGetUserShoresideOrShipsideLocationUseCase.mockSailorLocation = .ship
        mockMusterModeRepository.musterDrillMode = .info

        // When
        let result = sut.execute()

        // Then
        XCTAssertTrue(result, "Should return true when user is logged is on ship, and muster mode is disabled")
    }

}
