//
//  RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Abel Duarte on 8/30/24.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

final class RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCaseTests: XCTestCase {

	// Helper method to create sample booking details
	private func createSampleBookingDetails() -> ShipsideBookingReferenceDetails {
		return ShipsideBookingReferenceDetails(
			lastName: "Doe",
			cabinNumber: "1234",
			dateOfBirth: Date(timeIntervalSince1970: 0) // Jan 1, 1970
		)
	}

	func testBiometricAuthenticationSuccessAndBookingDetailsFound() async {
		// Arrange
		let mockRepository = MockShipsideBookingReferenceDetailsRepository()
		let mockBiometricService = MockBiometricAuthenticationService()
		let expectedBookingDetails = createSampleBookingDetails()
		mockRepository.save(expectedBookingDetails)

		let useCase = RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase(
			shipsideBookingReferenceDetailsRepository: mockRepository,
			biometricsAuthenticationService: mockBiometricService
		)

		// Act
		let result = await useCase.execute()

		// Assert
		switch result {
		case .success(let bookingDetails):
			XCTAssertEqual(bookingDetails.lastName, expectedBookingDetails.lastName)
			XCTAssertEqual(bookingDetails.cabinNumber, expectedBookingDetails.cabinNumber)
			XCTAssertEqual(bookingDetails.dateOfBirth, expectedBookingDetails.dateOfBirth)
		case .failure:
			XCTFail("Expected success but got failure")
		}
	}

	func testBiometricAuthenticationFails() async {
		// Arrange
		let mockRepository = MockShipsideBookingReferenceDetailsRepository()
		let mockBiometricService = MockBiometricAuthenticationService()
		mockBiometricService.shouldAuthenticateSucceed = false
		let expectedBookingDetails = createSampleBookingDetails()
		mockRepository.save(expectedBookingDetails)

		let useCase = RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase(
			shipsideBookingReferenceDetailsRepository: mockRepository,
			biometricsAuthenticationService: mockBiometricService
		)

		// Act
		let result = await useCase.execute()

		// Assert
		switch result {
		case .success:
			XCTFail("Expected failure but got success")
		case .failure(let error):
			XCTAssertEqual(error, .biometricAuthenticationFailed)
		}
	}

	func testBiometricAuthenticationUnavailable() async {
		// Arrange
		let mockRepository = MockShipsideBookingReferenceDetailsRepository()
		let mockBiometricService = MockBiometricAuthenticationService()
		mockBiometricService.isBiometricAvailable = false

		let useCase = RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase(
			shipsideBookingReferenceDetailsRepository: mockRepository,
			biometricsAuthenticationService: mockBiometricService
		)

		// Act
		let result = await useCase.execute()

		// Assert
		switch result {
		case .success:
			XCTFail("Expected failure but got success")
		case .failure(let error):
			XCTAssertEqual(error, .biometricUnavailable)
		}
	}

	func testBookingDetailsNotFound() async {
		// Arrange
		let mockRepository = MockShipsideBookingReferenceDetailsRepository()
		let mockBiometricService = MockBiometricAuthenticationService()
		// Don't save any booking details to the mock repository

		let useCase = RetrieveShipsideBookingReferenceDetailsWithBiometricsUseCase(
			shipsideBookingReferenceDetailsRepository: mockRepository,
			biometricsAuthenticationService: mockBiometricService
		)

		// Act
		let result = await useCase.execute()

		// Assert
		switch result {
		case .success:
			XCTFail("Expected failure but got success")
		case .failure(let error):
			XCTAssertEqual(error, .bookingDetailsNotFound)
		}
	}
}
