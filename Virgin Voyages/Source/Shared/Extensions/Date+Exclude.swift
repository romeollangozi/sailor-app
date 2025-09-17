//
//  Date+Exclude.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 2.5.25.
//

import Foundation

extension Array where Element == Date {
	func exclude(_ dates: [Date]) -> [Date] {
		return self.filter { x in !dates.contains { y in isSameDay(date1: x, date2: y) } }
	}
}
