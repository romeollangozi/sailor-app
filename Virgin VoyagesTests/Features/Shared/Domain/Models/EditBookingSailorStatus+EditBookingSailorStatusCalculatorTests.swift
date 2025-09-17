//
//  EditBookingSailorStatusTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.4.25.
//

import Foundation
import XCTest
@testable import Virgin_Voyages

final class EditBookingSailorStatusCalculatorTests: XCTestCase {
	
	var calculator: EditBookingSailorStatusCalculator!
	
	override func setUp() {
		super.setUp()
		calculator = EditBookingSailorStatusCalculator()
	}
	
	override func tearDown() {
		calculator = nil
		super.tearDown()
	}
	
	func testCalculateWithNewSailor() {
		let previousBookedSailorsIds = ["123"]
		let newBookedSailorsIds = ["123", "456"]
		let result = EditBookingSailorStatusCalculator.caclulate(previousBookedSailorsIds: previousBookedSailorsIds, newBookedSailorsIds: newBookedSailorsIds)
		XCTAssertEqual(result["456"], .new)
		XCTAssertEqual(result["123"], .confirmed)
	}
	
	func testCalculateWithCancelledSailor() {
		let previousBookedSailorsIds = ["123", "456"]
		let newBookedSailorsIds = ["123"]
		let result = EditBookingSailorStatusCalculator.caclulate(previousBookedSailorsIds: previousBookedSailorsIds, newBookedSailorsIds: newBookedSailorsIds)
		XCTAssertEqual(result["456"], .cancelled)
		XCTAssertEqual(result["123"], .confirmed)
	}
	
	func testCalculateWithNoChanges() {
		let previousBookedSailorsIds = ["123", "456"]
		let newBookedSailorsIds = ["123", "456"]
		let result = EditBookingSailorStatusCalculator.caclulate(previousBookedSailorsIds: previousBookedSailorsIds, newBookedSailorsIds: newBookedSailorsIds)
		XCTAssertEqual(result["123"], .confirmed)
		XCTAssertEqual(result["456"], .confirmed)
	}
	
	func testCalculateWithEmptyPreviousList() {
		let previousBookedSailorsIds: [String] = []
		let newBookedSailorsIds = ["123", "456"]
		let result = EditBookingSailorStatusCalculator.caclulate(previousBookedSailorsIds: previousBookedSailorsIds, newBookedSailorsIds: newBookedSailorsIds)
		XCTAssertEqual(result["123"], .new)
		XCTAssertEqual(result["456"], .new)
	}
	
	func testCalculateWithEmptyNewList() {
		let previousBookedSailorsIds = ["123", "456"]
		let newBookedSailorsIds: [String] = []
		let result = EditBookingSailorStatusCalculator.caclulate(previousBookedSailorsIds: previousBookedSailorsIds, newBookedSailorsIds: newBookedSailorsIds)
		XCTAssertEqual(result["123"], .cancelled)
		XCTAssertEqual(result["456"], .cancelled)
	}
}
