//
//  IntExtensionsTests.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 22.11.24.
//

import XCTest
@testable import Virgin_Voyages

final class IntToHoursAndMinutesTests: XCTestCase {
    func testZeroMinutes() {
        let result = 0.toHoursAndMinutesString()
        XCTAssertEqual(result, "0 minutes")
    }
    
    func testOnlyMinutes() {
        let result = 45.toHoursAndMinutesString()
        XCTAssertEqual(result, "45 minutes")
    }
    
    func testOneHour() {
        let result = 60.toHoursAndMinutesString()
        XCTAssertEqual(result, "1 hour")
    }
    
    func testMultipleHours() {
        let result = 180.toHoursAndMinutesString()
        XCTAssertEqual(result, "3 hours")
    }
    
    func testOneHourAndMinutes() {
        let result = 75.toHoursAndMinutesString()
        XCTAssertEqual(result, "1 hour and 15 minutes")
    }
    
    func testMultipleHoursAndMinutes() {
        let result = 135.toHoursAndMinutesString()
        XCTAssertEqual(result, "2 hours and 15 minutes")
    }
    
    func testExactMultipleOfHours() {
        let result = 240.toHoursAndMinutesString()
        XCTAssertEqual(result, "4 hours")
    }
    
    func testLessThanAnHour() {
        let result = 5.toHoursAndMinutesString()
        XCTAssertEqual(result, "5 minutes")
    }
}
