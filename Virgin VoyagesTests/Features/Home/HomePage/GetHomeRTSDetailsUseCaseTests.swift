//
//  GetHomeRTSDetailsUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 20.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetHomeRTSDetailsUseCaseTests: XCTestCase {
    
    var useCase: GetHomeRTSDetailsUseCase!
    var mockDashboardLandingRepository: MockDashboardLandingRepository!
    var mockSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockDashboardLandingRepository = MockDashboardLandingRepository()
        mockSailorManager = MockCurrentSailorManager()
        useCase = GetHomeRTSDetailsUseCase(
            dashboardLandingRepository: mockDashboardLandingRepository,
            currentSailorManager: mockSailorManager
        )
    }

    override func tearDown() {
        useCase = nil
        mockDashboardLandingRepository = nil
        mockSailorManager = nil
        super.tearDown()
    }

    func testExecuteWithValidResponseReturnsTaskDetail() async throws {
        // Given
        let expectedTaskDetail = TaskDetail(thumbnailImageUrl: "", title: "Review Travel Summary", description: "Complete your travel summary before departure", moduleKey: "ReadyToSail", sequence: 1, isEnabled: false, isHealthCheckComplete: false, isError: false, isFitToTravel: false, isCompleted: false)
        
        mockDashboardLandingRepository.mockTaskDetail = expectedTaskDetail
        mockSailorManager.lastSailor = CurrentSailor.sample()

        // When
        let result = try await useCase.execute()

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.moduleKey, expectedTaskDetail.moduleKey)
        XCTAssertEqual(result?.title, expectedTaskDetail.title)
        XCTAssertEqual(result?.description, expectedTaskDetail.description)
    }

    func testExecuteReturnsNilWhenRepositoryFails() async {
        // Given
        mockDashboardLandingRepository.shouldThrowError = true
        mockDashboardLandingRepository.errorToThrow = VVDomainError.genericError
        mockSailorManager.lastSailor = CurrentSailor.sample()

        // When
  
        do {
            let result = try await useCase.execute()
            XCTAssertNil(result)
        } catch { }
    }

    func testExecuteReturnsNilWhenTaskDetailIsMissing() async {
        // Given
        mockDashboardLandingRepository.mockTaskDetail = nil
        mockSailorManager.lastSailor = CurrentSailor.sample()

        // When
        do {
            let result = try await useCase.execute()
            XCTAssertNil(result)
        } catch { }
    }
}
