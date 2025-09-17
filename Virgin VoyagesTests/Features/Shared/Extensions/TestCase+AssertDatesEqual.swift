//
//  TestCase+AssertDatesEqual.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 21.4.25.
//

import XCTest

extension XCTestCase {
	func XCTAssertDatesEqual(_ date1: Date, _ date2: Date, calendar: Calendar = .current, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
		let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
		let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
		
		if components1 != components2 {
			let failureMessage = message().isEmpty ? "Dates are not equal: \(date1) and \(date2)" : message()
			XCTFail(failureMessage, file: file, line: line)
		}
	}
	
	func XCTAssertDatesContain(_ source: [Date], _ date2: Date, calendar: Calendar = .current, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
		let containsDate = source.contains { calendar.isDate($0, inSameDayAs: date2) }
		
		if !containsDate {
			let failureMessage = message().isEmpty ? "Dates are not equal: \(source) and \(date2)" : message()
			XCTFail(failureMessage, file: file, line: line)
		}
	}
}
