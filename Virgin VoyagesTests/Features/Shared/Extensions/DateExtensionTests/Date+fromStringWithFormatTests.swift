//
//  Date+fromStringWithFormatTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class DateFromStringWithFormatTests: XCTestCase {
	func testFromStringWithValidDateAndFormatReturnsDate() {
		let dateString = "2025-05-26"
		let format = "yyyy-MM-dd"
		
		let date = Date.fromStringWithFormat(string: dateString, format: format)
		
		XCTAssertNotNil(date, "Expected a valid Date object for the given string and format")
	}
	
	func testFromStringWithInvalidDateReturnsNil() {
		let dateString = "Invalid Date"
		let format = "yyyy-MM-dd"
		
		let date = Date.fromStringWithFormat(string: dateString, format: format)
		
		XCTAssertNil(date, "Expected nil for an invalid date string")
	}
	
	func testFromStringWithMismatchedFormatReturnsNil() {
		let dateString = "26-05-2025"
		let format = "yyyy-MM-dd"
		
		let date = Date.fromStringWithFormat(string: dateString, format: format)
		
		XCTAssertNil(date, "Expected nil for a mismatched date format")
	}
	
	func testFromStringWithDifferentLocaleStillParsesCorrectly() {
		let dateString = "May 26, 2025"
		let format = "MMMM dd, yyyy"
		
		let date = Date.fromStringWithFormat(string: dateString, format: format)
		
		XCTAssertNotNil(date, "Expected a valid Date object for the given string and format")
	}
	
	func testFromStringWithEmptyStringReturnsNil() {
		let dateString = ""
		let format = "yyyy-MM-dd"
		
		let date = Date.fromStringWithFormat(string: dateString, format: format)
		
		XCTAssertNil(date, "Expected nil for an empty date string")
	}
	
	func testFromStringWithEmptyFormatReturnsNil() {
		let dateString = "2025-05-26"
		let format = ""
		
		let date = Date.fromStringWithFormat(string: dateString, format: format)
		
		XCTAssertNil(date, "Expected nil for an empty format string")
	}
}
