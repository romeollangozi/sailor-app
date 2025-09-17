//
//  Date+Exclude.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 2.5.25.
//

import XCTest
@testable import Virgin_Voyages

class DateExcludeTests: XCTestCase {
	func testExcludeDates() {
	
		let calendar = Calendar.current
		let date1 = calendar.date(from: DateComponents(year: 2023, month: 10, day: 1))!
		let date2 = calendar.date(from: DateComponents(year: 2023, month: 10, day: 2))!
		let date3 = calendar.date(from: DateComponents(year: 2023, month: 10, day: 3))!
		let date4 = calendar.date(from: DateComponents(year: 2023, month: 10, day: 4))!
		
		let allDates = [date1, date2, date3, date4]
		let excludeDates = [date2, date4]
		
		
		let result = allDates.exclude(excludeDates)
		
		
		XCTAssertEqual(result.count, 2)
		XCTAssertTrue(result.contains(date1))
		XCTAssertTrue(result.contains(date3))
		XCTAssertFalse(result.contains(date2))
		XCTAssertFalse(result.contains(date4))
	}
	
	func testExcludeEmptyDates() {
		
		let calendar = Calendar.current
		let date1 = calendar.date(from: DateComponents(year: 2023, month: 10, day: 1))!
		let date2 = calendar.date(from: DateComponents(year: 2023, month: 10, day: 2))!
		
		let allDates = [date1, date2]
		let excludeDates: [Date] = []
		
		
		let result = allDates.exclude(excludeDates)
		
		
		XCTAssertEqual(result.count, 2)
		XCTAssertTrue(result.contains(date1))
		XCTAssertTrue(result.contains(date2))
	}
	
	func testExcludeAllDates() {
		
		let calendar = Calendar.current
		let date1 = calendar.date(from: DateComponents(year: 2023, month: 10, day: 1))!
		let date2 = calendar.date(from: DateComponents(year: 2023, month: 10, day: 2))!
		
		let allDates = [date1, date2]
		let excludeDates = [date1, date2]
		
		
		let result = allDates.exclude(excludeDates)
		
		
		XCTAssertEqual(result.count, 0)
	}
}
