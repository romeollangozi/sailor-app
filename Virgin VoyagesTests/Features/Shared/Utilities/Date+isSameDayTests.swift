//
//  Date+isSameDayTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.3.25.
//

import XCTest
@testable import Virgin_Voyages

class DateIsSameDayTests: XCTestCase {

	func testIsSameDay() {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone(secondsFromGMT: 0)!
		let today = Date()
		let sameDay = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: today)!
		let differentDay = calendar.date(byAdding: .day, value: 1, to: today)!

		XCTAssertTrue(isSameDay(date1: today, date2: sameDay), "Dates on the same day should return true")
		XCTAssertFalse(isSameDay(date1: today, date2: differentDay), "Dates on different days should return false")
	}
}
