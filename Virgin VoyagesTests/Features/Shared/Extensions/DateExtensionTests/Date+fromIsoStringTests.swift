//
//  Date+fromIsoStringTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 24.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class DateFromISOStringTests: XCTestCase {
	
	func testFromISOStringWithFullDateTime() {
		let isoString = "2023-05-24T14:30:00"
		let expectedDate = createUTCDate(year: 2023, month: 5, day: 24, hour: 14, minute: 30)
		let result = Date.fromISOString(string: isoString)
		XCTAssertEqual(result, expectedDate)
	}
	
	func testFromISOStringWithDateOnly() {
		let isoString = "2023-05-24"
		let expectedDate = createUTCDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0)
		let result = Date.fromISOString(string: isoString)
		XCTAssertEqual(result, expectedDate)
	}
	
	func testFromISOStringWithNilString() {
		let result = Date.fromISOString(string: nil)
		XCTAssertEqual(result.timeIntervalSince1970, Date().timeIntervalSince1970, accuracy: 1)
	}
	
	func testFromISOStringWithInvalidString() {
		let isoString = "invalid-date"
		let result = Date.fromISOString(string: isoString)
		XCTAssertEqual(result.timeIntervalSince1970, Date().timeIntervalSince1970, accuracy: 1)
	}
	
	private func createUTCDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0) -> Date {
		var dateComponents = DateComponents()
		dateComponents.year = year
		dateComponents.month = month
		dateComponents.day = day
		dateComponents.hour = hour
		dateComponents.minute = minute
		dateComponents.second = second
		
		var calendar = Calendar.current
		calendar.timeZone = TimeZone(secondsFromGMT: 0)! // UTC
		
		return calendar.date(from: dateComponents) ?? Date()
	}
}
