//
//  Date+isPastDate.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.3.25.
//

import Foundation

public func isPastDate(_ date: Date) -> Bool {
	var calendar = Calendar.current
	calendar.timeZone = TimeZone(secondsFromGMT: 0)!

	return calendar.compare(date, to: Date(), toGranularity: .day) == .orderedAscending
}
