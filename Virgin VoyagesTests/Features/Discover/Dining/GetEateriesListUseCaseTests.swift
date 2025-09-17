//
//  GetEateriesListUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.4.25.
//

//Need to write unit tests for GetEateriesListUseCase

import XCTest
@testable import Virgin_Voyages

final class GetEateriesListUseCaseTests: XCTestCase {
	var useCase: GetEateriesListUseCase!
	var mockEateriesListRepository: MockEateriesListRepository!
	var mockCurrentSailorManager: MockCurrentSailorManager!
	
	override func setUp() {
		super.setUp()
		mockEateriesListRepository = MockEateriesListRepository()
		mockCurrentSailorManager = MockCurrentSailorManager()
		
		useCase = GetEateriesListUseCase(
			eateriesListRepository: mockEateriesListRepository,
			currentSailorManager: mockCurrentSailorManager
		)
	}

	override func tearDown() {
		useCase = nil
		mockEateriesListRepository = nil
		mockCurrentSailorManager = nil
		super.tearDown()
	}
	
	func testExecuteShouldReturnEateriesList() async throws {
		let expected = EateriesList.sample()
		mockEateriesListRepository.mockEateriesList = expected

		let actual = try await useCase.execute(includePortsName: true, useCache: true)

		XCTAssertEqual(actual, expected)
	}

	func testGetEateryAppointmentDetailsFailure() async throws {
		mockEateriesListRepository.mockEateriesList = nil
		mockEateriesListRepository.shouldThrowError = true

		do {
			_ = try await useCase.execute(includePortsName: true, useCache: true)
			XCTFail("Expected to throw an error")
		} catch {
			XCTAssertNotNil(error)
		}
	}

}
