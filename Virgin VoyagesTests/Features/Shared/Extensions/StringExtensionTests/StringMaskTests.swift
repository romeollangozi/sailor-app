//
//  StringMaskTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 2.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class StringMaskingTests: XCTestCase {

	func testPartialPrefix_MasksCorrectly_ForStandardName() {
		let input = "Silver"
		let masked = input.masked(as: .partialPrefix)
		XCTAssertEqual(masked, "Si****")
	}

	func testPartialPrefix_MasksCorrectly_ForShortName() {
		let input = "Al"
		let masked = input.masked(as: .partialPrefix)
		XCTAssertEqual(masked, "Al***")
	}

	func testPartialPrefix_MasksCorrectly_ForVeryShortName() {
		let input = "J"
		let masked = input.masked(as: .partialPrefix)
		XCTAssertEqual(masked, "J****")
	}

	func testHideYear_MasksYearCorrectly() {
		let input = "Aug 28, 1986"
		let masked = input.masked(as: .hideYear)
		XCTAssertEqual(masked, "Aug 28, ****")
	}

	func testHideYear_WithInvalidDate_ReturnsInvalidDate() {
		let input = "28/08/1986"
		let masked = input.masked(as: .hideYear)
		XCTAssertEqual(masked, "")
	}
}
