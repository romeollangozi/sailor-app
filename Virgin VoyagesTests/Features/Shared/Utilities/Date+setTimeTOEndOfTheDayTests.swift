//
//  Date+setTimeTOEndOfTheDayTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.5.25.
//

import XCTest
@testable import Virgin_Voyages

class setTimeTOEndOfTheDayTests: XCTestCase {
	func testSetTimeToEndOfTheDay() {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone(abbreviation: "UTC")!
		var components = DateComponents()
		components.year = 2023
		components.month = 5
		components.day = 14
		components.hour = 10
		components.minute = 20
		components.second = 30
		let date = calendar.date(from: components)!
		
		let endOfDay = date.setTimeToEndOfTheDay()
		
		let expectedComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endOfDay)
		XCTAssertEqual(expectedComponents.hour, 23)
		XCTAssertEqual(expectedComponents.minute, 59)
		XCTAssertEqual(expectedComponents.second, 59)
	}
}
