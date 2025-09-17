//
//  Date+isPastDateTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.3.25.
//

import XCTest
@testable import Virgin_Voyages

class DateIsPastDateTests: XCTestCase {
	func testIsPastDate() {
		let calendar = Calendar.current
		let today = Date()
		let pastDate = calendar.date(byAdding: .day, value: -1, to: today)!
		let futureDate = calendar.date(byAdding: .day, value: 1, to: today)!

		XCTAssertTrue(isPastDate(pastDate), "Past date should return true")
		XCTAssertFalse(isPastDate(today), "Today's date should return false")
		XCTAssertFalse(isPastDate(futureDate), "Future date should return false")
	}
}
