//
//  Date+isFutureDay.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.5.25.
//

import Foundation

public func isFutureDay(_ date: Date) -> Bool {
	var calendar = Calendar.current
	calendar.timeZone = TimeZone(secondsFromGMT: 0)!
	
	return calendar.compare(date, to: Date(), toGranularity: .day) == .orderedDescending
}
