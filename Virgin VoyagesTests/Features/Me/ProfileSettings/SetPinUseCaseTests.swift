//
//  SetPinUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 22.7.25.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

class SetPinUseCaseTests: XCTestCase {

	var sut: SetPinUseCase!
	var mockCurrentSailorManager: MockCurrentSailorManager!
	var mockSetPinRepository: MockSetPinRepository!

	override func setUp() {
		super.setUp()
		mockCurrentSailorManager = MockCurrentSailorManager()
		mockSetPinRepository = MockSetPinRepository()
		sut = SetPinUseCase(
			currentSailorManager: mockCurrentSailorManager,
			setPinRepository: mockSetPinRepository
		)
	}

	override func tearDown() {
		sut = nil
		mockCurrentSailorManager = nil
		mockSetPinRepository = nil
		super.tearDown()
	}


	func testExecute_WhenCurrentSailorExistsAndRepositoryReturnsResponse_ShouldReturnEmptyModel() async throws {
		// Given
		let testPin = "1234"
		let expectedSailor = CurrentSailor.sample()
		let expectedResponse = EmptyModel()

		mockCurrentSailorManager.lastSailor = expectedSailor
		mockSetPinRepository.mockResponse = expectedResponse

		// When
		let result = try await sut.execute(pin: testPin)

		// Then
		XCTAssertNotNil(result, "Result should not be nil when repository returns a response")
		XCTAssertTrue(mockSetPinRepository.setPinCalled, "Repository setPin should be called")
		XCTAssertEqual(mockSetPinRepository.setPinInput?.pin, testPin, "Pin should match the input")
		XCTAssertEqual(mockSetPinRepository.setPinInput?.reservationGuestId, expectedSailor.reservationGuestId, "Reservation guest ID should match current sailor")
	}

	func testExecute_WhenRepositoryReturnsNil_ShouldReturnNil() async throws {
		// Given
		let testPin = "9999"
		let expectedSailor = CurrentSailor.sample()

		mockCurrentSailorManager.lastSailor = expectedSailor
		mockSetPinRepository.mockResponse = nil // Repository returns nil

		// When
		let result = try await sut.execute(pin: testPin)

		// Then
		XCTAssertNil(result, "Result should be nil when repository returns nil")
		XCTAssertTrue(mockSetPinRepository.setPinCalled, "Repository setPin should still be called")
		XCTAssertEqual(mockSetPinRepository.setPinInput?.pin, testPin, "Pin should match the input")
		XCTAssertEqual(mockSetPinRepository.setPinInput?.reservationGuestId, expectedSailor.reservationGuestId, "Reservation guest ID should match current sailor")
	}

	func testExecute_WhenRepositoryThrowsError_ShouldPropagateError() async {
		// Given
		let testPin = "0000"
		let expectedSailor = CurrentSailor.sample()
		let expectedError = VVDomainError.genericError

		mockCurrentSailorManager.lastSailor = expectedSailor
		mockSetPinRepository.shouldThrowError = true
		mockSetPinRepository.errorToThrow = expectedError

		// When & Then
		do {
			_ = try await sut.execute(pin: testPin)
			XCTFail("Should propagate error from repository")
		} catch {
			XCTAssertTrue(error is VVDomainError, "Should propagate VVDomainError")
			if let domainError = error as? VVDomainError {
				XCTAssertEqual(domainError, expectedError, "Should propagate the exact error from repository")
			}
			XCTAssertTrue(mockSetPinRepository.setPinCalled, "Repository should be called before throwing error")
			XCTAssertEqual(mockSetPinRepository.setPinInput?.pin, testPin, "Pin should match the input")
			XCTAssertEqual(mockSetPinRepository.setPinInput?.reservationGuestId, expectedSailor.reservationGuestId, "Reservation guest ID should match current sailor")
		}
	}
}
