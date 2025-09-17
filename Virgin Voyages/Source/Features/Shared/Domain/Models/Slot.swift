//
//  Slot.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 16.1.25.
//

import Foundation

struct Slot: Identifiable, Equatable, Hashable {
    let id: String
    let startDateTime: Date
    let endDateTime: Date
    let status: SlotStatus
    let isBooked: Bool
	let inventoryCount: Int

	var dayName: String {
		return startDateTime.weekdayName()
	}

	var timeText: String {
		return startDateTime.toHourMinute()
	}
	
	var statusText: String? {
		switch status {
			case .soldOut:
				return "Sold out"
			case .notAvailable:
				return "Not available"
			case .closed:
				return "BOOKING CLOSED"
			case .passed:
				return nil
			case .available:
				return "Available"
		}
	}

}

public enum SlotStatus: String {
    case available = "Available"
    case notAvailable = "NotAvailable"
    case closed = "Closed"
    case soldOut = "SoldOut"
    case passed = "Passed"
	
	init(from string: String) {
		self = SlotStatus(rawValue: string) ?? .available
	}
    
    var titleForCTA: String {
        switch self {
            case .soldOut, .passed:
                return "Booking Sold Out"
			case .closed:
				return "Booking Closed"
            case .available:
                return "Book"
            case .notAvailable:
                return "Booking Not Available"
        }
    }
}

extension Slot {
    static func sample(
        id: String = UUID().uuidString,
        startDateTime: Date = Date(),
        endDateTime: Date = Date(),
        status: SlotStatus = .available,
        isBooked: Bool = false,
        inventoryCount: Int = 100
    ) -> Slot {
        return Slot(
            id: id,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            status: status,
            isBooked: isBooked,
            inventoryCount: inventoryCount
        )
    }
    
    func copy(
        id: String? = nil,
        startDateTime: Date? = nil,
        endDateTime: Date? = nil,
        status: SlotStatus? = nil,
        isBooked: Bool? = nil,
		inventoryCount: Int? = nil
    ) -> Slot {
        return Slot(
            id: id ?? self.id,
            startDateTime: startDateTime ?? self.startDateTime,
            endDateTime: endDateTime ?? self.endDateTime,
            status: status ?? self.status,
            isBooked: isBooked ?? self.isBooked,
			inventoryCount: inventoryCount ?? self.inventoryCount
        )
    }
}

extension Slot {
	static func empty() -> Slot {
		return Slot(
			id: UUID().uuidString,
			startDateTime: Date(),
			endDateTime: Date(),
			status: .available,
			isBooked: false,
			inventoryCount: 0
		)
	}
}

extension Array where Element == Slot {
	func findByDate(for date: Date) -> [Slot] {
		return self.filter { isSameDay(date1: $0.startDateTime, date2: date)}
	}
	
    func findActiveByDate(for date: Date, isEditFlow: Bool) -> [Slot] {
        if !isEditFlow{
            return self.filter { isSameDay(date1: $0.startDateTime, date2: date) && $0.status == .available}
        }
        return self.filter { isSameDay(date1: $0.startDateTime, date2: date) && $0.status != .passed}
	}
	
	func findById(for id: String) -> Slot? {
		return self.first(where: { $0.id == id })
	}

	func uniqueSlots() -> [Slot] {
		let groupedById = Dictionary(grouping: self, by: \.id)
		return groupedById.compactMap { $0.value.first }
	}

	func sortedByStartDate() -> [Slot] {
		return self.sorted(by: { $0.startDateTime < $1.startDateTime })
	}
	
	func uniqueDates() -> [Date] {
		var uniqueDates: [Date] = []
		
		for slot in self {
			if !uniqueDates.contains(where: { isSameDay(date1: $0, date2: slot.startDateTime) }) {
				uniqueDates.append(slot.startDateTime)
			}
		}
		
		return uniqueDates.sorted(by: { $0 < $1 })
	}
	
	func hasSlotsWithInventoryGreaterThanOrEqualTo(_ count: Int) -> Bool {
		return self.count { $0.inventoryCount >= count } > 0
	}
}
