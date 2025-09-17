//
//  Date+fromISOString.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 24.5.25.
//

import Foundation

extension Date {
	static func fromISOString(string: String?) -> Date {
		if let string = string {
			let dateFormatter = DateFormatter()
			
			dateFormatter.dateFormat = string.contains("T") ? "yyyy-MM-dd'T'HH:mm:ss" : "yyyy-MM-dd"
			dateFormatter.locale = Locale(identifier: "en_US_POSIX")
			dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
			
			if let parsedDate = dateFormatter.date(from: string) {
				return parsedDate
			}
		}
		
		return Date()
	}
}
