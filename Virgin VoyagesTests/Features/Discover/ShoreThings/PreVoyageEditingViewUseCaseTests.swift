//
//  PreVoyageEditingViewUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 9.7.25.
//


import XCTest
@testable import Virgin_Voyages

class PreVoyageEditingViewUseCaseTests: XCTestCase {

	var sut: PreVoyageEditingViewUseCase!
	var mockLocalizationManager: MockLocalizationManager!
	var mockCurrentSailorManager: MockCurrentSailorManager!

	override func setUp() {
		super.setUp()
		mockLocalizationManager = MockLocalizationManager()
		mockCurrentSailorManager = MockCurrentSailorManager()
		sut = PreVoyageEditingViewUseCase(
			currentSailorManager: mockCurrentSailorManager,
			localizationManager: mockLocalizationManager
		)
	}

	override func tearDown() {
		sut = nil
		mockLocalizationManager = nil
		mockCurrentSailorManager = nil
		super.tearDown()
	}

	// MARK: - Test execute() with valid ship name

	func testExecute_WithValidShipName_ReturnsCorrectModel() {
		// Given
		let expectedShipName = "Scarlet Lady"
		let expectedTitle = "We're moving bookings and bags"
		let expectedDescriptionTemplate = "Our bookings are moving onto {ShipName}..."
		let expectedGoItButtonText = "Got it"

		let mockSailor = CurrentSailor.empty().copy(shipName: expectedShipName)
		mockCurrentSailorManager.lastSailor = mockSailor

		mockLocalizationManager.setString(expectedTitle, for: .movingBookingsAndBags)
		mockLocalizationManager.setString(expectedDescriptionTemplate, for: .preVoyageBookingStoppedDescription)
		mockLocalizationManager.setString(expectedGoItButtonText, for: .gotIt)

		// When
		let result = sut.execute()

		// Then
		XCTAssertEqual(result.title, expectedTitle)
		XCTAssertEqual(result.descriptionText, "Our bookings are moving onto Scarlet Lady...")
		XCTAssertEqual(result.goItButtonText, expectedGoItButtonText)
	}

	// MARK: - Test execute() with nil sailor

	func testExecute_WithNilSailor_ReturnsModelWithEmptyShipName() {
		// Given
		let expectedTitle = "We're moving bookings and bags"
		let expectedDescriptionTemplate = "Our bookings are moving onto {ShipName}..."
		let expectedGoItButtonText = "Got it"

		mockCurrentSailorManager.lastSailor = nil

		mockLocalizationManager.setString(expectedTitle, for: .movingBookingsAndBags)
		mockLocalizationManager.setString(expectedDescriptionTemplate, for: .preVoyageBookingStoppedDescription)
		mockLocalizationManager.setString(expectedGoItButtonText, for: .gotIt)

		// When
		let result = sut.execute()

		// Then
		XCTAssertEqual(result.title, expectedTitle)
		XCTAssertEqual(result.descriptionText, "Our bookings are moving onto ...")
		XCTAssertEqual(result.goItButtonText, expectedGoItButtonText)
	}

	// MARK: - Test execute() with empty ship name

	func testExecute_WithEmptyShipName_ReturnsModelWithEmptyShipName() {
		// Given
		let expectedTitle = "We're moving bookings and bags"
		let expectedDescriptionTemplate = "Our bookings are moving onto {ShipName}..."
		let expectedGoItButtonText = "Got it"

		let mockSailor = CurrentSailor.empty()
		mockCurrentSailorManager.lastSailor = mockSailor

		mockLocalizationManager.setString(expectedTitle, for: .movingBookingsAndBags)
		mockLocalizationManager.setString(expectedDescriptionTemplate, for: .preVoyageBookingStoppedDescription)
		mockLocalizationManager.setString(expectedGoItButtonText, for: .gotIt)

		// When
		let result = sut.execute()

		// Then
		XCTAssertEqual(result.title, expectedTitle)
		XCTAssertEqual(result.descriptionText, "Our bookings are moving onto ...")
		XCTAssertEqual(result.goItButtonText, expectedGoItButtonText)
	}
}
