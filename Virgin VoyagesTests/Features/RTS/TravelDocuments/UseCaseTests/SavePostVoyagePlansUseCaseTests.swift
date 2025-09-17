//
//  SavePostVoyagePlansUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class SavePostVoyagePlansUseCaseTests: XCTestCase {
    var useCase: SavePostVoyagePlansUseCase!
    var mockSailorManager: MockRtsCurrentSailorManager!
    var mockRepository: MockSavePostVoyagePlansRepository!

    override func setUp() {
        super.setUp()
        mockSailorManager = MockRtsCurrentSailorManager()
        mockRepository = MockSavePostVoyagePlansRepository()
        useCase = SavePostVoyagePlansUseCase(
            currentSailorManager: mockSailorManager,
            savePostVoyagePlansRepository: mockRepository
        )
    }

    override func tearDown() {
        useCase = nil
        mockSailorManager = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecute_Success() async throws {
        mockRepository.shouldThrowError = false
        let sampleInput = PostVoyagePlansInput.sample()

        do {
            let response = try await useCase.execute(input: sampleInput)
            XCTAssertNotNil(response)
        } catch {
            XCTFail("Expected success but received error: \(error)")
        }
    }

    func testExecute_Error() async {
        mockRepository.shouldThrowError = true
        let sampleInput = PostVoyagePlansInput.sample()

        do {
            _ = try await useCase.execute(input: sampleInput)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is VVDomainError)
            XCTAssertEqual(error as? VVDomainError, .genericError)
        }
    }
}

// MARK: - Mocks

final class MockSavePostVoyagePlansRepository: SavePostVoyagePlansRepositoryProtocol {
    var shouldThrowError = false

    func savePostVoyagePlans(reservationGuestId: String, input: PostVoyagePlansInput) async throws -> EmptyResponse? {
        if shouldThrowError {
            return nil
        } else {
            return EmptyResponse()
        }
    }
}
