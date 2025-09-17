//
//  Date+setTimeTOEndOfTheDay.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.5.25.
//

import Foundation

extension Date {
	func setTimeToEndOfTheDay() -> Date {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone(abbreviation: "UTC")!
		return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
	}
}
