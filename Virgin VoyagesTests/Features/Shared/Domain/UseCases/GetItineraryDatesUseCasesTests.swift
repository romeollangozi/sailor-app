//
//  GetItineraryDatesUseCasesTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetItineraryDatesUseCasesTests: XCTestCase {

	var mockCurrentSailorManager: MockCurrentSailorManager!
	var getItineraryDatesUseCase: GetItineraryDatesUseCase!

	override func setUp() {
		super.setUp()
		mockCurrentSailorManager = MockCurrentSailorManager()
		getItineraryDatesUseCase = GetItineraryDatesUseCase(currentSailorManager: mockCurrentSailorManager)
	}

	override func tearDown() {
		mockCurrentSailorManager = nil
		getItineraryDatesUseCase = nil
		super.tearDown()
	}

	func testExecuteReturnsItineraryDays() {
		
		let currentSailor = CurrentSailor.sample()
		let expectedItineraryDays = currentSailor.itineraryDays
		
		mockCurrentSailorManager.lastSailor = currentSailor

		
		let itineraryDays = getItineraryDatesUseCase.execute()

		
		XCTAssertEqual(itineraryDays, expectedItineraryDays)
	}

	func testExecuteReturnsEmptyItineraryDaysWhenNoCurrentSailor() {
		
		mockCurrentSailorManager.lastSailor = nil

		
		let itineraryDays = getItineraryDatesUseCase.execute()

		
		XCTAssertTrue(itineraryDays.isEmpty)
	}
}
