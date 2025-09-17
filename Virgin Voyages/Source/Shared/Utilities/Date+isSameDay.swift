//
//  Date+isSameDay.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.3.25.
//

import Foundation

public func isSameDay(date1: Date, date2: Date) -> Bool {
	var calendar = Calendar(identifier: .gregorian)
	calendar.timeZone = TimeZone(secondsFromGMT: 0)!

	let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
	let components2 = calendar.dateComponents([.year, .month, .day], from: date2)

	return components1 == components2
}
