//
//  SaveCitizenshipUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 9.9.25.
//

import XCTest
@testable import Virgin_Voyages

final class SaveCitizenshipUseCaseTests: XCTestCase {

    // SUT
    var useCase: SaveCitizenshipUseCase!

    // Mocks
    var mockRepo: MockSaveCitizenshipRepository!
    var rtsCurrentSailor: MockRtsCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockRepo = MockSaveCitizenshipRepository()
        rtsCurrentSailor = MockRtsCurrentSailorManager()
        _ = rtsCurrentSailor.setSailor(sailor: RtsCurrentSailor(reservationGuestId: "guest-123"))

        useCase = SaveCitizenshipUseCase(
            currentSailorManager: rtsCurrentSailor,
            saveCitizenshipRepository: mockRepo
        )
    }

    override func tearDown() {
        useCase = nil
        mockRepo = nil
        rtsCurrentSailor = nil
        super.tearDown()
    }

    func test_execute_success_injectsReservationGuestIdAndCallsRepository() async throws {
        // Given
        let input = CitizenshipModel(citizenshipCountryCode: "HK", reservationGuestId: nil)

        // When
        let response = try await useCase.execute(input: input)

        // Then
        XCTAssertNotNil(response, "Expected EmptyResponse()")
        XCTAssertEqual(mockRepo.invocations, 1, "Repository should be called once")

        let saved = try XCTUnwrap(mockRepo.lastSavedModel)
        XCTAssertEqual(saved.citizenshipCountryCode, "HK")
        XCTAssertEqual(saved.reservationGuestId, "guest-123", "Use case must inject current sailor's reservationGuestId")
    }

    func test_execute_overwritesExistingReservationGuestIdWithCurrentSailor() async throws {
        // Given: input already has a different id
        let input = CitizenshipModel(citizenshipCountryCode: "AL", reservationGuestId: "other-guest")

        // When
        _ = try await useCase.execute(input: input)

        // Then
        let saved = try XCTUnwrap(mockRepo.lastSavedModel)
        XCTAssertEqual(saved.citizenshipCountryCode, "AL")
        XCTAssertEqual(saved.reservationGuestId, "guest-123", "Per current implementation, SUT should overwrite with current sailor id")
    }

    func test_execute_forwardsRepositoryErrors() async {
        // Given
        mockRepo.shouldThrow = true
        mockRepo.errorToThrow = VVDomainError.genericError

        let input = CitizenshipModel(citizenshipCountryCode: "US", reservationGuestId: nil)

        // When / Then
        do {
            _ = try await useCase.execute(input: input)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is VVDomainError, "Expected VVDomainError, got \(error)")
        }
    }
}

// MARK: - Local Mock for SaveCitizenshipRepository

final class MockSaveCitizenshipRepository: SaveCitizenshipRepositoryProtocol {
    var lastSavedModel: CitizenshipModel?
    var invocations = 0
    var shouldThrow = false
    var errorToThrow: Error = VVDomainError.genericError

    func saveCitizenship(_ model: CitizenshipModel) async throws {
        invocations += 1
        if shouldThrow { throw errorToThrow }
        lastSavedModel = model
    }
}
