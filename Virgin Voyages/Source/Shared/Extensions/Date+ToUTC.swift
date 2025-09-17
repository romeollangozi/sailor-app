//
//  Date+ToUTC.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 31.7.25.
//

import Foundation

extension Date {
	func toUTCDateTime() -> Date {
		let timeZone = TimeZone(secondsFromGMT: 0)!
		var calendar = Calendar.current
		calendar.timeZone = TimeZone(abbreviation: "UTC")!
		var components = calendar.dateComponents(in: timeZone, from: self)
		components.timeZone = timeZone
		return calendar.date(from: components)!
	}
}
