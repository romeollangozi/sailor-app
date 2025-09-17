//
//  WidthOfStringTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class WidthOfStringTests: XCTestCase {
	func testSplitLinesWhenStringFitsInOneLine() {
		let string = "This is a small string"
		let maxLineWidth: CGFloat = 200
		let fontSize: CGFloat = 16

		let lines = string.splitLines(maxLineWidth: maxLineWidth, fontSize: fontSize)
		XCTAssertEqual(lines.count, 1, "The string should fit into one line.")
		XCTAssertEqual(lines.first, string, "The string was incorrectly split.")
	}

	func testSplitLinesWhenStringIsEmpty() {
		let string = ""
		let maxLineWidth: CGFloat = 100
		let fontSize: CGFloat = 16

		let lines = string.splitLines(maxLineWidth: maxLineWidth, fontSize: fontSize)
		XCTAssertTrue(lines.isEmpty, "An empty string should return an empty array.")
	}
}
