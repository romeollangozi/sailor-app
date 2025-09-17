//
//  Date+isFutureDayTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class IsFutureDayTests: XCTestCase {
	func testIsFutureDayWithFutureDateReturnsTrue() {
		let futureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
		XCTAssertTrue(isFutureDay(futureDate), "Expected true for a future date")
	}
	
	func testIsFutureDayWithPastDateReturnsFalse() {
		let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
		XCTAssertFalse(isFutureDay(pastDate), "Expected false for a past date")
	}
	
	func testIsFutureDayWithTodayReturnsFalse() {
		let today = Date()
		XCTAssertFalse(isFutureDay(today), "Expected false for today's date")
	}
	
	func testIsFutureDayWithDifferentTimeZoneStillReturnsCorrectResult() {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone(secondsFromGMT: 3600)! // 1 hour ahead
		let futureDate = calendar.date(byAdding: .day, value: 1, to: Date())!
		XCTAssertTrue(isFutureDay(futureDate), "Expected true for a future date in a different time zone")
	}
}
