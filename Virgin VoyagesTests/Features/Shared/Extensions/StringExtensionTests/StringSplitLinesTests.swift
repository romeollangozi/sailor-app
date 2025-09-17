//
//  StringSplitTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.3.25.
//

import XCTest
@testable import Virgin_Voyages

class StringSplitTests: XCTestCase {
	func testSplitLinesShouldSplitWordsCorrectly() {
		let string = "This is a test string for splitting into lines"
		let maxLineWidth: CGFloat = 100
		let fontSize: CGFloat = 16
		let font = UIFont.systemFont(ofSize: fontSize)
		let words = string.split(separator: " ")
		var wordWidths: [String: CGFloat] = [:]
		for word in words {
			let wordString = String(word)
			let attributes: [NSAttributedString.Key: Any] = [.font: font]
			let size = (wordString as NSString).size(withAttributes: attributes)
			wordWidths[wordString] = size.width
		}

		// Split the string into lines based on maxLineWidth
		let lines = string.splitLines(maxLineWidth: maxLineWidth, fontSize: fontSize)

		var currentLineWidth: CGFloat = 0
		var expectedLines: [String] = []
		var currentLine = ""

		for word in words {
			let wordWidth = wordWidths[String(word)] ?? 0
			if currentLineWidth + wordWidth <= maxLineWidth {
				currentLine += " \(word)"
				currentLineWidth += wordWidth
			} else {
				expectedLines.append(currentLine.trimmingCharacters(in: .whitespaces))
				currentLine = String(word)
				currentLineWidth = wordWidth
			}
		}

		if !currentLine.isEmpty {
			expectedLines.append(currentLine.trimmingCharacters(in: .whitespaces))
		}

		XCTAssertEqual(lines.count, expectedLines.count, "The string should be split into \(expectedLines.count) lines.")

		for (index, expectedLine) in expectedLines.enumerated() {
			XCTAssertEqual(lines[index], expectedLine, "Line \(index + 1) is incorrect.")
		}
	}
}
