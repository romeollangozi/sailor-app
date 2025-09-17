//
//  SlotTests.swift
//  Virgin VoyagesTests
//
//  Created by Enxhi Kondakciu on 9.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class SlotTests: XCTestCase {

    func test_statusText_forEachStatus_returnsCorrectValue() {
        let cases: [(SlotStatus, String?)] = [
            (.available, "Available"),
            (.notAvailable, "Not available"),
            (.closed, "BOOKING CLOSED"),
            (.soldOut, "Sold out"),
            (.passed, nil)
        ]

        for (status, expectedText) in cases {
            let slot = Slot.sample().copy(status: status)
            XCTAssertEqual(slot.statusText, expectedText)
        }
    }

    func test_findByDate_returnsCorrectSlots() {
        let date = Date()
        let sameDaySlot = Slot.sample().copy(startDateTime: date)
        let otherDaySlot = Slot.sample().copy(startDateTime: date.addingTimeInterval(86400))

        let result = [sameDaySlot, otherDaySlot].findByDate(for: date)
        XCTAssertEqual(result, [sameDaySlot])
    }

    func test_findActiveByDate_returnsOnlyAvailableSlots() {
        let date = Date()
        let available = Slot.sample().copy(startDateTime: date, status: .available)
        let closed = Slot.sample().copy(startDateTime: date, status: .closed)

        let result = [available, closed].findActiveByDate(for: date, isEditFlow: false)
        XCTAssertEqual(result, [available])
    }
    
    func test_findActiveByDate_returnsAllExceptPassedSlots() {
        let date = Date()
        let available = Slot.sample().copy(startDateTime: date, status: .available)
        let closed = Slot.sample().copy(startDateTime: date, status: .closed)
        let passed = Slot.sample().copy(startDateTime: date, status: .passed)

        let result = [available, closed, passed].findActiveByDate(for: date, isEditFlow: true)
        XCTAssertEqual(result, [available, closed])
    }

    func test_findById_returnsMatchingSlot() {
        let slot1 = Slot.sample().copy(id: "1")
        let slot2 = Slot.sample().copy(id: "2")

        let result = [slot1, slot2].findById(for: "2")
        XCTAssertEqual(result, slot2)
    }

    func test_uniqueSlots_removesDuplicatesById() {
        let original = Slot.sample().copy(id: "same")
        let duplicate = Slot.sample().copy(id: "same")

        let result = [original, duplicate].uniqueSlots()
        XCTAssertEqual(result.count, 1)
    }

    func test_sortedByStartDate_returnsSlotsInOrder() {
        let earlier = Slot.sample().copy(startDateTime: Date())
        let later = Slot.sample().copy(startDateTime: Date().addingTimeInterval(3600))

        let result = [later, earlier].sortedByStartDate()
        XCTAssertEqual(result, [earlier, later])
    }

    func test_uniqueDates_returnsDatesOnlyOnce() {
        let date = Date()
        let sameDay1 = Slot.sample().copy(startDateTime: date)
        let sameDay2 = Slot.sample().copy(startDateTime: date.addingTimeInterval(60))
        let otherDay = Slot.sample().copy(startDateTime: date.addingTimeInterval(86400))

        let result = [sameDay1, sameDay2, otherDay].uniqueDates()
        XCTAssertEqual(result.count, 2)
    }

    func test_hasSlotsWithInventoryGreaterThanOrEqualTo_returnsTrueIfAnyMatch() {
        let slot1 = Slot.sample().copy(inventoryCount: 3)
        let slot2 = Slot.sample().copy(inventoryCount: 1)

        XCTAssertTrue([slot1, slot2].hasSlotsWithInventoryGreaterThanOrEqualTo(2))
    }

    func test_hasSlotsWithInventoryGreaterThanOrEqualTo_returnsFalseIfNoneMatch() {
        let slot1 = Slot.sample().copy(inventoryCount: 1)
        let slot2 = Slot.sample().copy(inventoryCount: 0)

        XCTAssertFalse([slot1, slot2].hasSlotsWithInventoryGreaterThanOrEqualTo(2))
    }

    func testDayName() {
        let date = createUTCDate(year: 2023, month: 5, day: 24, hour: 0, minute: 0) // Wednesday
        let slot = Slot.sample().copy(startDateTime: date)

        let result = slot.dayName

        XCTAssertEqual(result, "Wednesday")
    }
}
