//
//  LineUp.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 9.4.25.
//

import Foundation

struct LineUp {
    let events: [LineUpEvents]
    let mustSeeEvents: [LineUpEvents]
    let leadTime: LeadTime?

    static func empty() -> LineUp {
        LineUp( events: [], mustSeeEvents:[], leadTime: nil)
    }
}

extension LineUp {
	func filterByDate(_ date: Date) -> [LineUpEvents] {
		return self.events.filter { isSameDay(date1: $0.date, date2: date) }
	}
    
    func filterByDateMustSeeEvents(_ date: Date) -> LineUpEvents? {
        return self.mustSeeEvents.first { isSameDay(date1: $0.date, date2: date) }
    }
}

