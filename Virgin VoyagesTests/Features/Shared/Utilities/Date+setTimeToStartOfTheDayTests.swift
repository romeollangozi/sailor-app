//
//  Date+setTimeToStartOfTheDayTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.5.25.
//

import XCTest
@testable import Virgin_Voyages

class setTimeToStartOfTheDayTests: XCTestCase {
	func testSetTimeToStartOfTheDay() {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone(abbreviation: "UTC")!
		var components = DateComponents()
		components.year = 2023
		components.month = 5
		components.day = 14
		components.hour = 15
		components.minute = 30
		components.second = 45
		let date = calendar.date(from: components)!
		
		let startOfDay = date.setTimeToStartOfTheDay()
		
		let expectedComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startOfDay)
		XCTAssertEqual(expectedComponents.hour, 0)
		XCTAssertEqual(expectedComponents.minute, 0)
		XCTAssertEqual(expectedComponents.second, 0)
	}
}
