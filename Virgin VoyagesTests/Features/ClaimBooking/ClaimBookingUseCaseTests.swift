//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/13/24.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

final class ClaimBookingUseCaseTests: XCTestCase {

	var mockBookingService: MockBookingService!
	var claimBookingUseCase: ClaimBookingUseCase!

	override func setUp() {
		super.setUp()
		mockBookingService = MockBookingService()
		claimBookingUseCase = ClaimBookingUseCase(bookingService: mockBookingService)
	}

	override func tearDown() {
		mockBookingService = nil
		claimBookingUseCase = nil
		super.tearDown()
	}

	func testClaimBookingSuccess() async {
		// Arrange
		mockBookingService.claimBookingResult = .success
		mockBookingService.reloadBookingResult = true

		// Act
		let result = await claimBookingUseCase.execute(
			email: "test@example.com",
			lastName: "Doe",
			birthDate: Date(),
			reservationNumber: "123456"
		)

		// Assert
		XCTAssertEqual(result, .success)
	}

	func testClaimBookingSuccessButReloadFails() async {
		// Arrange
		mockBookingService.claimBookingResult = .success
		mockBookingService.shouldReloadThrowError = true

		// Act
		let result = await claimBookingUseCase.execute(
			email: "test@example.com",
			lastName: "Doe",
			birthDate: Date(),
			reservationNumber: "123456"
		)

		// Assert
		XCTAssertEqual(result, .bookingNotFound)
	}

	func testClaimBookingNotFound() async {
		// Arrange
		mockBookingService.claimBookingResult = .bookingNotFound

		// Act
		let result = await claimBookingUseCase.execute(
			email: "test@example.com",
			lastName: "Doe",
			birthDate: Date(),
			reservationNumber: "123456"
		)

		// Assert
		XCTAssertEqual(result, .bookingNotFound)
	}

	func testClaimBookingEmailConflict() async {
		// Arrange
		mockBookingService.claimBookingResult = .emailConflict(email: "conflict@example.com",
                                                               reservationNumber: "",
                                                               reservationGuestID: "guest123")

		// Act
		let result = await claimBookingUseCase.execute(
			email: "test@example.com",
			lastName: "Doe",
			birthDate: Date(),
			reservationNumber: "123456"
		)

		// Assert
		switch result {
        case .emailConflict(let email, _, let reservationGuestID):
			XCTAssertEqual(email, "conflict@example.com")
			XCTAssertEqual(reservationGuestID, "guest123")
		default:
			XCTFail("Expected emailConflict but got \(result)")
		}
	}
    
    func testClaimBookingWithReCaptchaToken() async {
        mockBookingService.claimBookingResult = .success
        mockBookingService.reloadBookingResult = true

        let result = await claimBookingUseCase.execute(
            email: "recaptcha@test.com",
            lastName: "Smith",
            birthDate: Date(),
            reservationNumber: "ABC123",
            reservationGuestID: "guest456",
            reCaptchaToken: "mock-token-123"
        )

        XCTAssertEqual(result, .success)
    }

}
