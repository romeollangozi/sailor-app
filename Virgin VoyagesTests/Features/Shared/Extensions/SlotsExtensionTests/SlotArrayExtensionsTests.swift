//
//  SlotArrayExtensionsTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 20.5.25.
//


import XCTest
@testable import Virgin_Voyages

final class SlotArrayExtensionsTests: XCTestCase {

    func test_uniqueSlots_removesDuplicatesById() {
        let now = Date()
        let slot1 = Slot(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(3600), status: .available, isBooked: false, inventoryCount: 1)
        let slot2 = Slot(id: "2", startDateTime: now, endDateTime: now.addingTimeInterval(3600), status: .available, isBooked: false, inventoryCount: 1)
        let duplicateSlot1 = slot1.copy()

        let slots = [slot1, slot2, duplicateSlot1]

        let unique = slots.uniqueSlots()

        XCTAssertEqual(unique.count, 2, "Expected 2 unique slots by ID")
        XCTAssertTrue(unique.contains(where: { $0.id == "1" }))
        XCTAssertTrue(unique.contains(where: { $0.id == "2" }))
    }

    func test_sortedByStartDate_sortsAscending() {
        let now = Date()
        let slot1 = Slot(id: "1", startDateTime: now.addingTimeInterval(3600), endDateTime: now.addingTimeInterval(7200), status: .available, isBooked: false, inventoryCount: 1)
        let slot2 = Slot(id: "2", startDateTime: now, endDateTime: now.addingTimeInterval(3600), status: .available, isBooked: false, inventoryCount: 1)
        let slot3 = Slot(id: "3", startDateTime: now.addingTimeInterval(1800), endDateTime: now.addingTimeInterval(5400), status: .available, isBooked: false, inventoryCount: 1)

        let sorted = [slot1, slot2, slot3].sortedByStartDate()

        XCTAssertEqual(sorted.map { $0.id }, ["2", "3", "1"], "Slots should be sorted by startDateTime in ascending order")
    }
}