//
//  ItineraryDayTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 13.1.25.
//
import Foundation
import XCTest

@testable import Virgin_Voyages

final class ItineraryDayTests: XCTestCase {
	var mockItineraries: [ItineraryDay]!
	
	override func setUp() {
		super.setUp()
		mockItineraries = [
			ItineraryDay(itineraryDay: 1, isSeaDay: false, portCode: "MIA", day: "Saturday", dayOfWeek: "S", dayOfMonth: "28", date: ISO8601DateFormatter().date(from: "2024-12-28T00:00:00Z")!, portName: "Miami"),
			ItineraryDay(itineraryDay: 2, isSeaDay: true, portCode: "", day: "Sunday", dayOfWeek: "S", dayOfMonth: "29", date: ISO8601DateFormatter().date(from: "2024-12-29T00:00:00Z")!, portName: ""),
			ItineraryDay(itineraryDay: 3, isSeaDay: false, portCode: "POP", day: "Monday", dayOfWeek: "M", dayOfMonth: "30", date: ISO8601DateFormatter().date(from: "2024-12-30T00:00:00Z")!, portName: "Puerto Plata")
		]
	}
	
	override func tearDown() {
		mockItineraries = nil
		super.tearDown()
	}
	
	func testFindItineraryExactMatch() {
		let date = ISO8601DateFormatter().date(from: "2024-12-30T00:00:00Z")!
		let result = mockItineraries.findItinerary(for: date)
		XCTAssertNotNil(result)
		XCTAssertEqual(result?.itineraryDay, 3)
		XCTAssertEqual(result?.portName, "Puerto Plata")
	}
	
	func testFindItineraryNoMatch() {
		let date = ISO8601DateFormatter().date(from: "2025-01-01T00:00:00Z")! // Date not in the itinerary
		let result = mockItineraries.findItinerary(for: date)
		XCTAssertNil(result) // Should return nil
	}
	
	func testGetDates() {
		let dates = mockItineraries.getDates()
		
		XCTAssertEqual(dates.count, 3)
		XCTAssertEqual(dates[0], ISO8601DateFormatter().date(from: "2024-12-28T00:00:00Z")!)
		XCTAssertEqual(dates[1], ISO8601DateFormatter().date(from: "2024-12-29T00:00:00Z")!)
		XCTAssertEqual(dates[2], ISO8601DateFormatter().date(from: "2024-12-30T00:00:00Z")!)
	}
	
	func testGetDatesReturnsUniqueDates() {
		let dates = [
			ItineraryDay(itineraryDay: 1, isSeaDay: false, portCode: "MIA", day: "Saturday", dayOfWeek: "S", dayOfMonth: "28", date: ISO8601DateFormatter().date(from: "2024-12-28T00:00:00Z")!, portName: "Miami"),
			ItineraryDay(itineraryDay: 2, isSeaDay: true, portCode: "", day: "Sunday", dayOfWeek: "S", dayOfMonth: "28", date: ISO8601DateFormatter().date(from: "2024-12-28T00:00:00Z")!, portName: ""),
			ItineraryDay(itineraryDay: 3, isSeaDay: false, portCode: "POP", day: "Monday", dayOfWeek: "M", dayOfMonth: "30", date: ISO8601DateFormatter().date(from: "2024-12-30T00:00:00Z")!, portName: "Puerto Plata")
		].getDates()
		
		XCTAssertEqual(dates.count, 2)
		XCTAssertEqual(dates[0], ISO8601DateFormatter().date(from: "2024-12-28T00:00:00Z")!)
		XCTAssertEqual(dates[1], ISO8601DateFormatter().date(from: "2024-12-30T00:00:00Z")!)
	}
}
