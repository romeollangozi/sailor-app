//
//  BookingReferenceLoginUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Abel Duarte on 8/30/24.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

final class BookingReferenceLoginUseCaseTests: XCTestCase {

	var useCase: LoginUseCaseProtocol!
	var mockCredentialsService: MockCredentialsService!
	var mockAuthenticationService: MockAuthenticationService!
	var mockShoresideRepository: MockShoresideBookingReferenceDetailsRepository!
	var mockShipsideRepository: MockShipsideBookingReferenceDetailsRepository!

	override func setUp() {
		super.setUp()
		mockCredentialsService = MockCredentialsService()
		mockAuthenticationService = MockAuthenticationService()
		mockShoresideRepository = MockShoresideBookingReferenceDetailsRepository()
		mockShipsideRepository = MockShipsideBookingReferenceDetailsRepository()

		useCase = LoginUseCase(
			credentialsService: mockCredentialsService,
			authenticationService: mockAuthenticationService,
			shoresideBookingReferenceDetailsRepository: mockShoresideRepository,
			shipsideBookingReferenceDetailsRepository: mockShipsideRepository
		)
	}

	override func tearDown() {
		useCase = nil
		mockCredentialsService = nil
		mockAuthenticationService = nil
		mockShoresideRepository = nil
		mockShipsideRepository = nil
		super.tearDown()
	}

	func testExecuteWithCabinNumberSuccess() async {
		// Given
		let cabinNumber = "123"
		let lastName = "Doe"
		let birthDate = Date()

		// When
        do {
            try await useCase.execute(.cabin(cabinNumber: cabinNumber, lastName: lastName, birthday: birthDate))
        } catch {
            XCTFail("No error expected")
        }

		// Then
		XCTAssertNotNil(mockShipsideRepository.savedDetails)
		XCTAssertEqual(mockShipsideRepository.savedDetails?.cabinNumber, cabinNumber)
		XCTAssertEqual(mockShipsideRepository.savedDetails?.lastName, lastName)
		XCTAssertEqual(mockShipsideRepository.savedDetails?.dateOfBirth, birthDate)
	}

	func testExecuteWithCabinNumberFailure() async {
		// Given
        mockAuthenticationService.shouldThrowError = true
		let cabinNumber = "123"
		let lastName = "Doe"
		let birthDate = Date()

		// When
        do {
            try await useCase.execute(.cabin(cabinNumber: cabinNumber, lastName: lastName, birthday: birthDate))
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }

		// Then
		XCTAssertNil(mockShipsideRepository.savedDetails)
	}

	func testExecuteWithReservationNumberSuccess() async {
		// Given
		let lastName = "Doe"
		let reservationNumber = "ABC123"
		let birthDate = Date()
		let sailDate = Date()

		// When
        do {
            try await useCase.execute(.reservation(lastName: lastName, reservationNumber: reservationNumber, birthDate: birthDate, sailDate: sailDate))
        } catch {
            XCTFail("No error expected")
        }

		// Then
		XCTAssertNotNil(mockShoresideRepository.savedDetails)
		XCTAssertEqual(mockShoresideRepository.savedDetails?.bookingReferenceNumber, reservationNumber)
		XCTAssertEqual(mockShoresideRepository.savedDetails?.lastName, lastName)
		XCTAssertEqual(mockShoresideRepository.savedDetails?.dateOfBirth, birthDate)
		XCTAssertEqual(mockShoresideRepository.savedDetails?.sailDate, sailDate)
	}

	func testExecuteWithReservationNumberFailure() async {
		// Given
        mockAuthenticationService.shouldThrowError = true
		let lastName = "Doe"
		let reservationNumber = "ABC123"
		let birthDate = Date()
		let sailDate = Date()

		// When
        do {
            try await useCase.execute(.reservation(lastName: lastName, reservationNumber: reservationNumber, birthDate: birthDate, sailDate: sailDate))
            XCTFail("Expected an error but got a result")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }
		
		// Then
		XCTAssertNil(mockShoresideRepository.savedDetails)
	}
}
