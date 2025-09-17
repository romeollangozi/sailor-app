//
//  RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Abel Duarte on 8/30/24.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

class RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCaseTests: XCTestCase {

	func testBiometricsUnavailable() async {
		let mockRepository = MockShoresideBookingReferenceDetailsRepository()
		let mockBiometricService = MockBiometricAuthenticationService()
		mockBiometricService.isBiometricAvailable = false

		let useCase = RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase(shoresideBookingReferenceDetailsRepository: mockRepository, biometricsAuthenticationService: mockBiometricService)

		let result = await useCase.execute()

		switch result {
		case .failure(let error):
			XCTAssertEqual(error, .biometricUnavailable)
		default:
			XCTFail("Expected biometricUnavailable error but got \(result)")
		}
	}

	func testBookingDetailsNotFound() async {
		let mockRepository = MockShoresideBookingReferenceDetailsRepository()
		let mockBiometricService = MockBiometricAuthenticationService()
		mockBiometricService.isBiometricAvailable = true

		let useCase = RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase(shoresideBookingReferenceDetailsRepository: mockRepository, biometricsAuthenticationService: mockBiometricService)

		let result = await useCase.execute()

		switch result {
		case .failure(let error):
			XCTAssertEqual(error, .bookingDetailsNotFound)
		default:
			XCTFail("Expected bookingDetailsNotFound error but got \(result)")
		}
	}

	func testBiometricAuthenticationSuccess() async {
		let mockRepository = MockShoresideBookingReferenceDetailsRepository()
		let mockBiometricService = MockBiometricAuthenticationService()
		mockBiometricService.isBiometricAvailable = true
		mockBiometricService.shouldAuthenticateSucceed = true

		let expectedBookingDetails = ShoresideBookingReferenceDetails(
			lastName: "Doe",
			bookingReferenceNumber: "ABC123",
			dateOfBirth: Date(timeIntervalSince1970: 315569260), // Replace with specific date
			sailDate: Date(timeIntervalSince1970: 1700000000) // Replace with specific date
		)
		mockRepository.save(expectedBookingDetails)

		let useCase = RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase(shoresideBookingReferenceDetailsRepository: mockRepository, biometricsAuthenticationService: mockBiometricService)

		let result = await useCase.execute()

		switch result {
		case .success(let bookingDetails):
			XCTAssertEqual(bookingDetails.lastName, expectedBookingDetails.lastName)
			XCTAssertEqual(bookingDetails.bookingReferenceNumber, expectedBookingDetails.bookingReferenceNumber)
			XCTAssertEqual(bookingDetails.dateOfBirth, expectedBookingDetails.dateOfBirth)
			XCTAssertEqual(bookingDetails.sailDate, expectedBookingDetails.sailDate)
		default:
			XCTFail("Expected success but got \(result)")
		}
	}

	func testBiometricAuthenticationFailed() async {
		let mockRepository = MockShoresideBookingReferenceDetailsRepository()
		let mockBiometricService = MockBiometricAuthenticationService()
		mockBiometricService.isBiometricAvailable = true
		mockBiometricService.shouldAuthenticateSucceed = false

		let expectedBookingDetails = ShoresideBookingReferenceDetails(
			lastName: "Doe",
			bookingReferenceNumber: "ABC123",
			dateOfBirth: Date(timeIntervalSince1970: 315569260), // Replace with specific date
			sailDate: Date(timeIntervalSince1970: 1700000000) // Replace with specific date
		)
		mockRepository.save(expectedBookingDetails)

		let useCase = RetrieveShoresideBookingReferenceDetailsWithBiometricsUseCase(shoresideBookingReferenceDetailsRepository: mockRepository, biometricsAuthenticationService: mockBiometricService)

		let result = await useCase.execute()

		switch result {
		case .failure(let error):
			XCTAssertEqual(error, .biometricAuthenticationFailed)
		default:
			XCTFail("Expected biometricAuthenticationFailed error but got \(result)")
		}
	}
}
