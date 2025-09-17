//
//  Calendar+createDateTests.swift
//  Virgin VoyagesTests
//
//  Created by Kevin Topollaj on 6/18/25.
//

import XCTest
@testable import Virgin_Voyages

class CalendarCreateDateTests: XCTestCase {
    
    func test_createDate_withValidDoubleComponents_returnsCorrectDate() {
        let components: [Double] = [2025.0, 6.0, 26.0]
        let expectedDateString = "2025-06-26T00:00:00Z"
        
        let result = createDate(from: components)
        
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let expectedDate = formatter.date(from: expectedDateString)
        
        XCTAssertEqual(result, expectedDate)
    }
    
    func test_createDate_withValidIntComponents_returnsCorrectDate() {
        let components: [Int] = [2025, 6, 26]
        let expectedDateString = "2025-06-26T00:00:00Z"
        
        let result = createDate(from: components)
        
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let expectedDate = formatter.date(from: expectedDateString)
        
        XCTAssertEqual(result, expectedDate)
    }
    
    func test_createDate_withInvalidComponentCount_returnsNil() {
        let components: [Int] = [2025, 6] // Missing day
        let result = createDate(from: components)
        
        XCTAssertNil(result)
    }
    
}
