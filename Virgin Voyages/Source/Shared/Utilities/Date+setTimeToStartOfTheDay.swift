//
//  Date+SetTimeToStartOfTheDay.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.5.25.
//

import Foundation

extension Date {
	func setTimeToStartOfTheDay() -> Date {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone(abbreviation: "UTC")!
		return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
	}
}
	