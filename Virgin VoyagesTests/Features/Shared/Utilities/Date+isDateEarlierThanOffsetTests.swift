//
//  Date+isDateEarlierThanOffsetTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 30.6.25.
//

import XCTest
@testable import Virgin_Voyages

class DateIsEarlierThanOffsetTests: XCTestCase {

    func testDateIsBeforeThreshold_shouldReturnTrue() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let dateToCheck = formatter.date(from: "2024-10-01")!
        let referenceDate = formatter.date(from: "2025-06-01")!

        XCTAssertTrue(
            isDateEarlierThanOffset(dateToCheck, months: 6, from: referenceDate),
            "Date before threshold should return true"
        )
    }

    func testDateIsExactlyAtThreshold_shouldReturnFalse() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let thresholdDate = formatter.date(from: "2025-12-01")!
        let referenceDate = formatter.date(from: "2025-06-01")!

        XCTAssertFalse(
            isDateEarlierThanOffset(thresholdDate, months: 6, from: referenceDate),
            "Date exactly at threshold should return false"
        )
    }

    func testDateIsAfterThreshold_shouldReturnFalse() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let dateToCheck = formatter.date(from: "2026-01-01")!
        let referenceDate = formatter.date(from: "2025-06-01")!

        XCTAssertFalse(
            isDateEarlierThanOffset(dateToCheck, months: 6, from: referenceDate),
            "Date after threshold should return false"
        )
    }

}
