//
//  Date+fromStringWithFormat.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.5.25.
//

import Foundation

extension Date {
	static func fromStringWithFormat(string: String, format: String) -> Date? {
		
		let dateFormatter = DateFormatter()
		
		dateFormatter.dateFormat = format
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
		
		if let parsedDate = dateFormatter.date(from: string) {
			return parsedDate
		}
		
		
		return nil
	}
}
