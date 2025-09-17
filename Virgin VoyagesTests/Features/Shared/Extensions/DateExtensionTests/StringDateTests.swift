//
//  StringDateTests.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/3/25.
//

import XCTest
@testable import Virgin_Voyages

class StringDateTests: XCTestCase {

	func testFromMMDDYYYYToDate_valid() {
		let dateString = "04-03-2025"
		guard let date = dateString.fromMMDDYYYYToDate() else {
			XCTFail("Expected valid date, got nil")
			return
		}

		let calendar = Calendar.current
		XCTAssertEqual(calendar.component(.year, from: date), 2025)
		XCTAssertEqual(calendar.component(.month, from: date), 4)
		XCTAssertEqual(calendar.component(.day, from: date), 3)
	}

	func testFromYYYYMMDD_valid() {
		let dateString = "2025-04-03"
		guard let date = dateString.fromYYYYMMDD() else {
			XCTFail("Expected valid date, got nil")
			return
		}

		let calendar = Calendar.current
		XCTAssertEqual(calendar.component(.year, from: date), 2025)
		XCTAssertEqual(calendar.component(.month, from: date), 4)
		XCTAssertEqual(calendar.component(.day, from: date), 3)
	}

	func testFromMMMMdYYYY_valid() {
		let dateString = "April 3 2025"
		guard let date = dateString.fromMMMMdYYYY() else {
			XCTFail("Expected valid date, got nil")
			return
		}

		let calendar = Calendar.current
		XCTAssertEqual(calendar.component(.year, from: date), 2025)
		XCTAssertEqual(calendar.component(.month, from: date), 4)
		XCTAssertEqual(calendar.component(.day, from: date), 3)
	}


	func testToUTCDate_valid() {
		let dateString = "2025-04-03T10:15:30"
		guard let date = dateString.toUTCDateTime() else {
			XCTFail("Expected valid UTC date, got nil")
			return
		}

		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		let expectedString = formatter.string(from: date)
		XCTAssertEqual(expectedString, "2025-04-03T10:15:30")
	}


    func testTimeAgoNow() {
            let date = Date() // now
            XCTAssertEqual(date.timeAgoString(), "now")
        }

        func testTimeAgoUnderOneMinute() {
            let date = Date().addingTimeInterval(-30) // 30 seconds ago
            XCTAssertEqual(date.timeAgoString(), "now")
        }

        func testTimeAgoMinutes() {
            let date = Date().addingTimeInterval(-120) // 2 minutes ago
            XCTAssertEqual(date.timeAgoString(), "2 min")
        }

        func testTimeAgoHours() {
            let date = Date().addingTimeInterval(-7200) // 2 hours ago
            XCTAssertEqual(date.timeAgoString(), "2h")
        }

        func testTimeAgoExactlyOneDay() {
            let date = Date().addingTimeInterval(-86400) // exactly 1 day ago
            XCTAssertEqual(date.timeAgoString(), "1 day")
        }

        func testTimeAgoMultipleDays() {
            let date = Date().addingTimeInterval(-3 * 86400) // 3 days ago
            XCTAssertEqual(date.timeAgoString(), "3 days")
        }
}
