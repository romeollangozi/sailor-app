//
//  Date+IsTodayTests.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/14/25.
//

import XCTest
@testable import Virgin_Voyages

class DateExtensionsTests: XCTestCase {

	func testIsToday_WithTodayDate_ShouldReturnTrue() {
		// Given: A date that is today
		let today = Date()

		// When: Checking if it's today
		let result = today.isToday

		// Then: It should return true
		XCTAssertTrue(result, "The isToday property should return true for today's date.")
	}

	func testIsToday_WithYesterdayDate_ShouldReturnFalse() {
		// Given: A date that is yesterday
		let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

		// When: Checking if it's today
		let result = yesterday.isToday

		// Then: It should return false
		XCTAssertFalse(result, "The isToday property should return false for a date that is not today (yesterday).")
	}

	func testIsToday_WithTomorrowDate_ShouldReturnFalse() {
		// Given: A date that is tomorrow
		let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!

		// When: Checking if it's today
		let result = tomorrow.isToday

		// Then: It should return false
		XCTAssertFalse(result, "The isToday property should return false for a date that is not today (tomorrow).")
	}
}
