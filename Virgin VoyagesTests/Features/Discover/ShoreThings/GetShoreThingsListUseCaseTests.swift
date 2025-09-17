//
//  GetShoreThingsListUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 31.7.25.
//

import XCTest
import Foundation
@testable import Virgin_Voyages

final class GetShoreThingsListUseCaseItemsCountTests: XCTestCase {

	private var mockCurrentSailorManager: MockCurrentSailorManager!
	private var mockShoreThingsRepository: MockShoreThingsRepository!
	private var useCase: GetShoreThingsListUseCase!

	override func setUp() {
		super.setUp()
		mockCurrentSailorManager = MockCurrentSailorManager()
		mockShoreThingsRepository = MockShoreThingsRepository()
		useCase = GetShoreThingsListUseCase(
			currentSailorManager: mockCurrentSailorManager,
			shoreThingsRepository: mockShoreThingsRepository
		)

		let sailors = SailorModel.samples()
		let mockSailor = CurrentSailor.sample().copy(reservationGuestId: sailors[0].reservationGuestId)
		mockCurrentSailorManager.lastSailor = mockSailor
	}

	override func tearDown() {
		mockCurrentSailorManager = nil
		mockShoreThingsRepository = nil
		useCase = nil
		super.tearDown()
	}

	// MARK: - Items Count Tests

	func testExecute_WithEmptyList_ReturnsZeroItems() async throws {
		// Given
		mockShoreThingsRepository.mockShoreThingsList = ShoreThingsList.empty()

		// When
		let result = try await useCase.execute(
			portCode: "MIA",
			arrivalDateTime: Date(),
			departureDateTime: Date(),
			useCache: true
		)

		// Then
		XCTAssertEqual(result.items.count, 0)
		XCTAssertEqual(result.types.count, 0)
		XCTAssertEqual(result.title, "")
		XCTAssertEqual(result.description, "")
	}

	func testExecute_WithSingleItem_ReturnsOneItem() async throws {
		// Given
		mockShoreThingsRepository.mockShoreThingsList = ShoreThingsList.sample()

		// When
		let result = try await useCase.execute(
			portCode: "BCN",
			arrivalDateTime: Date(),
			departureDateTime: Date(),
			useCache: false
		)

		// Then
		XCTAssertEqual(result.items.count, 1)
		XCTAssertEqual(result.types.count, 7)
		XCTAssertEqual(result.title, "Far more than just a home port")
		XCTAssertFalse(result.description.isEmpty)
	}

	func testExecute_WithMultipleItems_ReturnsCorrectItemCount() async throws {
		// Given
		mockShoreThingsRepository.mockShoreThingsList = ShoreThingsList.samplewithMultipleExcursions()

		// When
		let result = try await useCase.execute(
			portCode: "BIM",
			arrivalDateTime: Date(),
			departureDateTime: Date(),
			useCache: true
		)

		// Then
		XCTAssertEqual(result.items.count, 2)
		XCTAssertEqual(result.types.count, 7)
		XCTAssertEqual(result.title, "Those Bimini blues")
		XCTAssertFalse(result.description.isEmpty)
	}

	func testExecute_WithCustomItemCount_ReturnsExactCount() async throws {
		// Given - Create a custom list with 5 items
		let customItems = [
			ShoreThingItem.sample().copy(id: "1", name: "Beach Tour"),
			ShoreThingItem.sample().copy(id: "2", name: "City Walk"),
			ShoreThingItem.sample().copy(id: "3", name: "Museum Visit"),
			ShoreThingItem.sample().copy(id: "4", name: "Food Experience"),
			ShoreThingItem.sample().copy(id: "5", name: "Cultural Tour")
		]

		let customList = ShoreThingsList.sample().copy(items: customItems)
		mockShoreThingsRepository.mockShoreThingsList = customList

		// When
		let result = try await useCase.execute(
			portCode: "ROM",
			arrivalDateTime: Date(),
			departureDateTime: Date(),
			useCache: false
		)

		// Then
		XCTAssertEqual(result.items.count, 5)
		XCTAssertEqual(result.items[0].name, "Beach Tour")
		XCTAssertEqual(result.items[1].name, "City Walk")
		XCTAssertEqual(result.items[2].name, "Museum Visit")
		XCTAssertEqual(result.items[3].name, "Food Experience")
		XCTAssertEqual(result.items[4].name, "Cultural Tour")
	}

	func testExecute_VerifiesAllItemsHavePortCodeAndDate() async throws {
		// Given
		let portCode = "MIA"
		let arrivalDate = createDate(year: 2025, month: 9, day: 15, hour: 8, minute: 0)
		mockShoreThingsRepository.mockShoreThingsList = ShoreThingsList.samplewithMultipleExcursions()

		// When
		let result = try await useCase.execute(
			portCode: portCode,
			arrivalDateTime: arrivalDate,
			departureDateTime: arrivalDate,
			useCache: true
		)

		// Then
		XCTAssertEqual(result.items.count, 2)

		for item in result.items {
			XCTAssertEqual(item.portCode, portCode)
		}
	}
}

final class ShoreThingDateRangeHelperComprehensiveTests: XCTestCase {

	// MARK: - Both Dates Available Tests

	func testGetShoreThingDateRange_BothDatesAvailable_ReturnsUTCConvertedDates() {
		// Given
		let arrivalDateTime = createDate(year: 2025, month: 8, day: 15, hour: 9, minute: 0)
		let departureDateTime = createDate(year: 2025, month: 8, day: 15, hour: 18, minute: 30)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: arrivalDateTime,
			departureDateTime: departureDateTime
		)

		// Then
		let expectedStartDate = arrivalDateTime.toUTCDateTime()
		let expectedEndDate = departureDateTime.toUTCDateTime()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	func testGetShoreThingDateRange_BothDatesAvailableDifferentDays_ReturnsUTCConvertedDates() {
		// Given
		let arrivalDateTime = createDate(year: 2025, month: 8, day: 15, hour: 22, minute: 0)
		let departureDateTime = createDate(year: 2025, month: 8, day: 16, hour: 2, minute: 30)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: arrivalDateTime,
			departureDateTime: departureDateTime
		)

		// Then
		let expectedStartDate = arrivalDateTime.toUTCDateTime()
		let expectedEndDate = departureDateTime.toUTCDateTime()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	func testGetShoreThingDateRange_BothDatesExactSameTime_ReturnsUTCConvertedDates() {
		// Given
		let sameDateTime = createDate(year: 2025, month: 6, day: 21, hour: 14, minute: 45)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: sameDateTime,
			departureDateTime: sameDateTime
		)

		// Then
		let expectedStartDate = sameDateTime.toUTCDateTime()
		let expectedEndDate = sameDateTime.toUTCDateTime()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	// MARK: - Only Arrival Date Tests

	func testGetShoreThingDateRange_OnlyArrivalDate_ReturnsUTCStartAndEndOfDay() {
		// Given
		let arrivalDateTime = createDate(year: 2025, month: 8, day: 15, hour: 10, minute: 30)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: arrivalDateTime,
			departureDateTime: nil
		)

		// Then
		let expectedStartDate = arrivalDateTime.toUTCDateTime()
		let expectedEndDate = arrivalDateTime.setTimeToEndOfTheDay()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	func testGetShoreThingDateRange_OnlyArrivalDateLateNight_ReturnsUTCStartAndEndOfDay() {
		// Given
		let arrivalDateTime = createDate(year: 2025, month: 12, day: 31, hour: 23, minute: 30)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: arrivalDateTime,
			departureDateTime: nil
		)

		// Then
		let expectedStartDate = arrivalDateTime.toUTCDateTime()
		let expectedEndDate = arrivalDateTime.setTimeToEndOfTheDay()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	func testGetShoreThingDateRange_OnlyArrivalDateEarlyMorning_ReturnsUTCStartAndEndOfDay() {
		// Given
		let arrivalDateTime = createDate(year: 2025, month: 3, day: 10, hour: 0, minute: 1)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: arrivalDateTime,
			departureDateTime: nil
		)

		// Then
		let expectedStartDate = arrivalDateTime.toUTCDateTime()
		let expectedEndDate = arrivalDateTime.setTimeToEndOfTheDay()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	// MARK: - Only Departure Date Tests

	func testGetShoreThingDateRange_OnlyDepartureDate_ReturnsUTCStartAndEndOfDay() {
		// Given
		let departureDateTime = createDate(year: 2025, month: 8, day: 15, hour: 18, minute: 30)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: nil,
			departureDateTime: departureDateTime
		)

		// Then
		let expectedStartDate = departureDateTime.toUTCDateTime()
		let expectedEndDate = departureDateTime.setTimeToEndOfTheDay()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	func testGetShoreThingDateRange_OnlyDepartureDateMidnight_ReturnsUTCStartAndEndOfDay() {
		// Given
		let departureDateTime = createDate(year: 2025, month: 5, day: 20, hour: 0, minute: 0)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: nil,
			departureDateTime: departureDateTime
		)

		// Then
		let expectedStartDate = departureDateTime.toUTCDateTime()
		let expectedEndDate = departureDateTime.setTimeToEndOfTheDay()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	func testGetShoreThingDateRange_OnlyDepartureDateLateEvening_ReturnsUTCStartAndEndOfDay() {
		// Given
		let departureDateTime = createDate(year: 2025, month: 9, day: 5, hour: 22, minute: 45)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: nil,
			departureDateTime: departureDateTime
		)

		// Then
		let expectedStartDate = departureDateTime.toUTCDateTime()
		let expectedEndDate = departureDateTime.setTimeToEndOfTheDay()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	// MARK: - Edge Cases

	func testGetShoreThingDateRange_LeapYearFebruary_HandlesDatesCorrectly() {
		let arrivalDateTime = createDate(year: 2024, month: 2, day: 28, hour: 12, minute: 0)
		let departureDateTime = createDate(year: 2024, month: 2, day: 29, hour: 14, minute: 0)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: arrivalDateTime,
			departureDateTime: departureDateTime
		)

		// Then
		let expectedStartDate = arrivalDateTime.toUTCDateTime()
		let expectedEndDate = departureDateTime.toUTCDateTime()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	func testGetShoreThingDateRange_DifferentMonths_HandlesDatesCorrectly() {
		// Given
		let arrivalDateTime = createDate(year: 2025, month: 11, day: 30, hour: 10, minute: 0)
		let departureDateTime = createDate(year: 2025, month: 12, day: 2, hour: 8, minute: 0)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: arrivalDateTime,
			departureDateTime: departureDateTime
		)

		// Then
		let expectedStartDate = arrivalDateTime.toUTCDateTime()
		let expectedEndDate = departureDateTime.toUTCDateTime()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	func testGetShoreThingDateRange_DifferentYears_HandlesDatesCorrectly() {
		// Given
		let arrivalDateTime = createDate(year: 2025, month: 12, day: 30, hour: 15, minute: 30)
		let departureDateTime = createDate(year: 2026, month: 1, day: 2, hour: 11, minute: 0)

		// When
		let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: arrivalDateTime,
			departureDateTime: departureDateTime
		)

		// Then
		let expectedStartDate = arrivalDateTime.toUTCDateTime()
		let expectedEndDate = departureDateTime.toUTCDateTime()

		XCTAssertEqual(result.start, expectedStartDate)
		XCTAssertEqual(result.end, expectedEndDate)
	}

	// MARK: - UTC Conversion Validation Tests

	func testGetShoreThingDateRange_ValidatesUTCConversion() {

		let testCases = [
			createDate(year: 2025, month: 1, day: 1, hour: 6, minute: 30),
			createDate(year: 2025, month: 6, day: 15, hour: 12, minute: 0),
			createDate(year: 2025, month: 12, day: 31, hour: 18, minute: 45),
			createDate(year: 2025, month: 8, day: 20, hour: 23, minute: 59)
		]

		for arrivalDateTime in testCases {
			let departureDateTime = Calendar.current.date(byAdding: .hour, value: 2, to: arrivalDateTime)!

			// When
			let result = ShoreThingDateRangeHelper.getShoreThingDateRange(
				arrivalDateTime: arrivalDateTime,
				departureDateTime: departureDateTime
			)

			// Then
			let expectedStartDate = arrivalDateTime.toUTCDateTime()
			let expectedEndDate = departureDateTime.toUTCDateTime()

			XCTAssertEqual(result.start, expectedStartDate, "Start date should be UTC converted")
			XCTAssertEqual(result.end, expectedEndDate, "End date should be UTC converted")
		}
	}

	func testGetShoreThingDateRange_SingleDateScenariosUseUTCForStart() {
		let testDate = createDate(year: 2025, month: 7, day: 10, hour: 14, minute: 30)

		// When - Only arrival date
		let resultArrivalOnly = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: testDate,
			departureDateTime: nil
		)

		// When - Only departure date
		let resultDepartureOnly = ShoreThingDateRangeHelper.getShoreThingDateRange(
			arrivalDateTime: nil,
			departureDateTime: testDate
		)

		// Then
		let expectedUTCDate = testDate.toUTCDateTime()
		let expectedEndOfDay = testDate.setTimeToEndOfTheDay()

		XCTAssertEqual(resultArrivalOnly.start, expectedUTCDate, "Arrival-only start should be UTC converted")
		XCTAssertEqual(resultArrivalOnly.end, expectedEndOfDay, "Arrival-only end should be end of day")

		XCTAssertEqual(resultDepartureOnly.start, expectedUTCDate, "Departure-only start should be UTC converted")
		XCTAssertEqual(resultDepartureOnly.end, expectedEndOfDay, "Departure-only end should be end of day")
	}
}

// MARK: - Test Helpers

private func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
	let calendar = Calendar.current
	let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
	return calendar.date(from: components) ?? Date()
}
