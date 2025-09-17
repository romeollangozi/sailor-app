//
//  IteneraryDay.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 13.1.25.
//

import Foundation

struct ItineraryDay: Codable, Equatable {
    let itineraryDay: Int
    let isSeaDay: Bool
    let portCode: String
    let day: String
    let dayOfWeek: String
    let dayOfMonth: String
    let date: Date
    let portName: String
}

extension ItineraryDay {
	static func sample() -> ItineraryDay {
		return ItineraryDay(
			itineraryDay: 1,
			isSeaDay: false,
			portCode: "NYC",
			day: "Monday",
			dayOfWeek: "Mon",
			dayOfMonth: "1",
			date: Date(),
			portName: "New York"
		)
	}
}

extension ItineraryDay {
	static func samples() -> [ItineraryDay] {
		return [
			ItineraryDay(
				itineraryDay: 1,
				isSeaDay: false,
				portCode: "NYC",
				day: "Monday",
				dayOfWeek: "Mon",
				dayOfMonth: "1",
				date: Date(),
				portName: "New York"
			),
			ItineraryDay(
				itineraryDay: 2,
				isSeaDay: true,
				portCode: "SEA",
				day: "Tuesday",
				dayOfWeek: "Tue",
				dayOfMonth: "2",
				date: Date().addingTimeInterval(86400), // +1 day
				portName: "At Sea"
			),
			ItineraryDay(
				itineraryDay: 3,
				isSeaDay: false,
				portCode: "MIA",
				day: "Wednesday",
				dayOfWeek: "Wed",
				dayOfMonth: "3",
				date: Date().addingTimeInterval(2 * 86400), // +2 days
				portName: "Miami"
			)
		]
	}
}

extension Array where Element == ItineraryDay {
    func findItinerary(for date: Date) -> ItineraryDay? {
        return self.first { isSameDay(date1: $0.date, date2: date) }
    }
	
	func getDates() -> [Date] {
		/* Some times a voyage has 2 itinerary in the same date for example in 2 different ports, that us why we take unique dates */
		let uniqueDates = Set(self.map { $0.date })
		return uniqueDates.sorted()
	}
	
	func findItineraryDateOrDefault(for now: Date) -> Date {
		if let matchingItinerary = findItinerary(for: now) {
			return matchingItinerary.date
		}
		
		return self.first?.date ?? Date()
	}
}


extension ItineraryDay {
	func copy(
		itineraryDay: Int? = nil,
		isSeaDay: Bool? = nil,
		portCode: String? = nil,
		day: String? = nil,
		dayOfWeek: String? = nil,
		dayOfMonth: String? = nil,
		date: Date? = nil,
		portName: String? = nil
	) -> ItineraryDay {
		return ItineraryDay(
			itineraryDay: itineraryDay ?? self.itineraryDay,
			isSeaDay: isSeaDay ?? self.isSeaDay,
			portCode: portCode ?? self.portCode,
			day: day ?? self.day,
			dayOfWeek: dayOfWeek ?? self.dayOfWeek,
			dayOfMonth: dayOfMonth ?? self.dayOfMonth,
			date: date ?? self.date,
			portName: portName ?? self.portName
		)
	}
}
