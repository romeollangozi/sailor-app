//
//  MarkMusterDrillVideoAsWatchedUseCaseTests.swift
//  Virgin Voyages
//
//  Created by TX on 15.4.25.
//


import XCTest
@testable import Virgin_Voyages

final class MarkMusterDrillVideoAsWatchedUseCaseTests: XCTestCase {

    var useCase: MarkMusterDrillVideoAsWatchedUseCase!
    var mockRepo: MockMusterDrillRepository!
    var mockCurrentSailor: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockRepo = MockMusterDrillRepository()
        mockCurrentSailor = MockCurrentSailorManager()
        useCase = MarkMusterDrillVideoAsWatchedUseCase(
            repository: mockRepo,
            currentSailor: mockCurrentSailor
        )
    }

    override func tearDown() {
        useCase = nil
        mockRepo = nil
        mockCurrentSailor = nil
        super.tearDown()
    }

    func testExecute_success_callsRepositoryWithCorrectParams() async throws {
        try await useCase.execute()

        XCTAssertTrue(mockRepo.markCalled)
        XCTAssertEqual(mockRepo.calledShipCode, "")
        XCTAssertEqual(mockRepo.calledCabinNumber, "")
    }

    func testExecute_throwsError_whenRepositoryFails() async {
        mockRepo.shouldThrow = true

        do {
            try await useCase.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            // You can validate the error type if needed
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
}
