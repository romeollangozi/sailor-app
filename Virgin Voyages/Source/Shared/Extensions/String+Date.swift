//
//  String+Date.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/10/24.
//

import Foundation

extension String {
    func fromMMDDYYYYToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
    
    func fromYYYYMMDD() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
    
    func fromMMMMdYYYY() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }

	func toUTCDateTime() -> Date? {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC

		return formatter.date(from: self)
	}
}
