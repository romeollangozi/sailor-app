//
//  IntToTimeWithUTCOffsetTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 4/9/25.
//

import XCTest
@testable import Virgin_Voyages

final class IntToTimeWithUTCOffsetTests: XCTestCase {
    
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: date)
    }

    func testZeroOffset() {
        let offset = 0
        let expected = format(date: Date())
        let result = offset.toTimeWithUTCOffsetInMinutes()
        XCTAssertEqual(result, expected, "Time with zero offset should match current time.")
    }
    
    func testPositiveOffset() {
        let offset = 60
        let expected = format(date: Calendar.current.date(byAdding: .minute, value: 60, to: Date())!)
        let result = offset.toTimeWithUTCOffsetInMinutes()
        XCTAssertEqual(result, expected, "Time with +60 minute offset should be one hour ahead.")
    }
    
    func testNegativeOffset() {
        let offset = -120
        let expected = format(date: Calendar.current.date(byAdding: .minute, value: -120, to: Date())!)
        let result = offset.toTimeWithUTCOffsetInMinutes()
        XCTAssertEqual(result, expected, "Time with -120 minute offset should be two hours behind.")
    }
    
    func testInvalidOffsetReturnsEmptyString() {
        let offset = -1
        let result = offset.toTimeWithUTCOffsetInMinutes()
        XCTAssertEqual(result, "", "Offset of -1 should return an empty string.")
    }
    
}
