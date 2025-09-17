//
//  DateStringTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 24.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class DateStringTests: XCTestCase {
	
	func testToHourMinute() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 14, minute: 30)
		
		let result = date.toHourMinute()
		
		XCTAssertEqual(result, "2:30 pm")
	}
	
	
	func testToUSDateFormat() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0)
		let result = date.toUSDateFormat()
		XCTAssertEqual(result, "05/24/2023")
	}
	
	func testToHourMinuteDeviceTimeLowercaseMeridiem() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 14, minute: 30)
		let result = date.toHourMinuteDeviceTimeLowercaseMeridiem()
		XCTAssertEqual(result, "2:30pm")
	}
	
	func testToYearMMdd() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0)
		let result = date.toYearMMdd()
		XCTAssertEqual(result, "2023-05-24")
	}
	
	func testToMonthDayYear() {
		let date = createDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0)
		let result = date.toMonthDayYear()
		XCTAssertEqual(result, "05-24-2023")
	}
	
	func testToMonthDDYYY() {
		let date = createDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0)
		let result = date.toMonthDDYYY()
		XCTAssertEqual(result, "May 24 2023")
	}
	
	func testToISO8601() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 14, minute: 30)
		let result = date.toISO8601()
		XCTAssertEqual(result, "2023-05-24T14:30:00")
	}
	
	func testWeekdayName() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0)
		let result = date.weekdayName()
		XCTAssertEqual(result, "Wednesday")
	}
	
	func testToDayMonthDayTime() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 14, minute: 30)
		let result = date.toDayMonthDayTime()
		XCTAssertEqual(result, "Wed May 24, 2:30pm")
	}
    
    func testToMonthDayTime() {
        let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 14, minute: 30)
        let result = date.toMonthDayTime()
        XCTAssertEqual(result, "May 24 - 2:30pm")
    }
	
	func testToDayMonthDayNumber() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0)
		let result = date.toDayMonthDayNumber()
		XCTAssertEqual(result, "Wednesday, May 24")
	}
	
	func testToDayWithOrdinal() {
//		let date = createUTCDate(year: 2023, month: 5, day: 21, hour: 0, minute: 0)
//		let result = date.toDayWithOrdinal()
//		XCTAssertEqual(result, "Sun 21st")
	}
	
	func testToLetter() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0)
		let result = date.toLetter()
		XCTAssertEqual(result, "Wed")
	}
	
	func testToDayNumber() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0)
		let result = date.toDayNumber()
		XCTAssertEqual(result, "24")
	}
	
	func testToFullDateTimeWithOrdinal() {
		let date = createUTCDate(year: 2023, month: 5, day: 21, hour: 14, minute: 30)
		let result = date.toFullDateTimeWithOrdinal()
		XCTAssertEqual(result, "Sunday 21st 2:30pm")
	}
	
	func testTimeAgoDisplay() {
		let now = Date()
		
		let secondsAgo = now.addingTimeInterval(-30) // 30 seconds ago
		XCTAssertEqual(secondsAgo.timeAgoDisplay(), "30 seconds ago")
		
		let minutesAgo = now.addingTimeInterval(-120) // 2 minutes ago
		XCTAssertEqual(minutesAgo.timeAgoDisplay(), "2 minutes ago")
		
		let hoursAgo = now.addingTimeInterval(-7200) // 2 hours ago
		XCTAssertEqual(hoursAgo.timeAgoDisplay(), "2 hours ago")
		
		let daysAgo = now.addingTimeInterval(-172800) // 2 days ago
		XCTAssertEqual(daysAgo.timeAgoDisplay(), "2 days ago")
		
		let weeksAgo = now.addingTimeInterval(-604800) // 1 week ago
		XCTAssertEqual(weeksAgo.timeAgoDisplay(), "1 week ago")
		
		let monthsAgo = now.addingTimeInterval(-2592000) // 1 month ago
		XCTAssertEqual(monthsAgo.timeAgoDisplay(), "1 month ago")
	}
	
	func testDayAndTimeFormattedString() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 14, minute: 30)
		let result = date.dayAndTimeFormattedString()
		XCTAssertEqual(result, "Wed, 2:30pm")
	}
	
	func testShortWeekdayFullMonthDayTime() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 14, minute: 30)
		let result = date.shortWeekdayFullMonthDayTime()
		XCTAssertEqual(result, "Wed May 24, 2:30 pm")
	}
	
	func testToWeekdayDay() {
		let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0)
		let result = date.toWeekdayDay()
		XCTAssertEqual(result, "Wednesday 24")
	}
	
	func testTimeAgoString() {
		let now = Date()
		
		let secondsAgo = now.addingTimeInterval(-30) // 30 seconds ago
		XCTAssertEqual(secondsAgo.timeAgoString(), "now")
		
		let minutesAgo = now.addingTimeInterval(-120) // 2 minutes ago
		XCTAssertEqual(minutesAgo.timeAgoString(), "2 min")
		
		let hoursAgo = now.addingTimeInterval(-7200) // 2 hours ago
		XCTAssertEqual(hoursAgo.timeAgoString(), "2h")
		
		let daysAgo = now.addingTimeInterval(-172800) // 2 days ago
		XCTAssertEqual(daysAgo.timeAgoString(), "2 days")
		
		let weeksAgo = now.addingTimeInterval(-604800) // 1 week ago
		XCTAssertEqual(weeksAgo.timeAgoString(), "7 days")
		
		let monthsAgo = now.addingTimeInterval(-2592000) // 1 month ago
		XCTAssertEqual(monthsAgo.timeAgoString(), "30 days")
	}
}
