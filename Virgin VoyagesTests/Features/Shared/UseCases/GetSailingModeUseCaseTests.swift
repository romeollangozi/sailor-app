//
//  GetSailingModeUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 13.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetSailingModeUseCaseTests: XCTestCase {
    
    var useCase: GetSailingModeUseCase!
    var mockVoyageRepository: MockMyVoyageRepository!
    var mockSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockVoyageRepository = MockMyVoyageRepository()
        mockSailorManager = MockCurrentSailorManager()
        useCase = GetSailingModeUseCase(
            myVoyageRepository: mockVoyageRepository,
            currentSailorManager: mockSailorManager
        )
    }

    override func tearDown() {
        useCase = nil
        mockVoyageRepository = nil
        mockSailorManager = nil
        super.tearDown()
    }

    func testExecuteReturnsSailingMode() async throws {
        mockVoyageRepository.mockSailingMode = .shipBoardSeaDay
        mockSailorManager.lastSailor = CurrentSailor.sample()

        let result = try await useCase.execute()

        XCTAssertEqual(result, .shipBoardSeaDay, "Expected sailing mode to be shipBoardSeaDay")
    }

    func testExecuteThrowsErrorWhenVoyageRepositoryFails() async {
        mockVoyageRepository.shouldThrowError = true
        mockVoyageRepository.errorToThrow = VVDomainError.genericError
        mockSailorManager.lastSailor = CurrentSailor.sample()

        do {
            _ = try await useCase.execute()
            XCTFail("Expected error but got a successful response")
        } catch {
            XCTAssertEqual(error as? VVDomainError, VVDomainError.genericError, "Expected VVDomainError.genericError")
        }
    }
}
