//
//  GetMusterDrillContentUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 10.4.25.
//
import XCTest
@testable import Virgin_Voyages

final class GetMusterDrillContentUseCaseTests: XCTestCase {
    
    var useCase: GetMusterDrillContentUseCase!
    var mockRepository: MockMusterDrillRepository!
    var mockSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockRepository = MockMusterDrillRepository()
        mockSailorManager = MockCurrentSailorManager()
        useCase = GetMusterDrillContentUseCase(
            repository: mockRepository,
            currentSailorManager: mockSailorManager
        )
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        mockSailorManager = nil
        super.tearDown()
    }

    func testExecuteReturnsMusterDrillContent_WhenRepositoryReturnsData() async throws {
        // Given
        let expectedContent = MusterDrillContent.empty()
        mockRepository.mockResponse = expectedContent
        mockSailorManager.lastSailor = CurrentSailor.sample()

        // When
        let result = try await useCase.execute()

        // Then
        XCTAssertEqual(result.video.title, expectedContent.video.title)
    }

    func testExecuteThrowsError_WhenRepositoryReturnsNil() async {
        // Given
        mockRepository.mockResponse = nil
        mockSailorManager.lastSailor = CurrentSailor.sample()

        do {
            // When
            _ = try await useCase.execute()
            XCTFail("Expected error but got result")
        } catch {
            // Then
            XCTAssertEqual(error as? VVDomainError, .notFound)
        }
    }
}
