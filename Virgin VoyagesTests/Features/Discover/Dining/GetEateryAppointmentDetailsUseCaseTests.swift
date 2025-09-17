//
//  GetEateryAppointmentDetailsUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

import XCTest
@testable import Virgin_Voyages

class GetEateryAppointmentDetailsUseCaseTests: XCTestCase {
	var useCase: GetEateryAppointmentDetailsUseCase!
	var repository: MockEateriesAppointmentRepository!

	override func setUp() {
		super.setUp()
		repository = MockEateriesAppointmentRepository()
		useCase = GetEateryAppointmentDetailsUseCase(
			eateriesAppointmentRepository: repository,
			currentSailorManager: MockCurrentSailorManager()
		)
	}

	override func tearDown() {
		useCase = nil
		repository = nil
		super.tearDown()
	}

	func testGetEateryAppointmentDetailsSuccess() async throws {
		let expectedDetails = EateryAppointmentDetails.sample()
		repository.mockResponse = expectedDetails

		let result = try await useCase.execute(appointmentId: "2b5b5710-1278-43a6-93ff-15a505cd8f6e")

		XCTAssertEqual(result, expectedDetails)
	}

	func testGetEateryAppointmentDetailsFailure() async throws {
		repository.mockResponse = nil
		repository.shouldThrowError = true

		do {
			_ = try await useCase.execute(appointmentId: "invalid-id")
			XCTFail("Expected to throw an error")
		} catch {
			XCTAssertNotNil(error)
		}
	}
}
