//
//  Date.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/3/23.
//

import Foundation

enum DateStyle {
	case time
	case shortTime
	case timeOfDay
	case hour
	case title
	case shortTitle
	case iso8601
	case iso8601date
	case dayName
	case dayLetter
	case short
	case dayTime
	case dateTitle
	case dayNumber
	case monthShortName
	case slashDate
	case shortDayNameNumber
	case shortOrdinal
	case travelDocument
	case hour24
	
	var format: String {
		switch self {
		case .time: return "h:mma"
		case .shortTime: return "h:mm"
		case .timeOfDay: return "a"
		case .hour: return "ha"
		case .iso8601: return "yyyy-MM-dd'T'HH:mm:ss"
		case .title: return "E MMMM d, h:mma"
		case .shortTitle: return "E, MMM d"
		case .dateTitle: return "EEEE, MMMM d"
		case .dayName: return "EEEE"
		case .dayLetter: return "E"
		case .shortDayNameNumber: return "EEE dd"
		case .short: return "h:mma, EEEE"
		case .dayTime: return "EEEE, h:mma"
		case .monthShortName: return "MMM"
		case .dayNumber: return "d"
		case .slashDate: return "MM/dd/yyyy"
		case .iso8601date: return "yyyy-MM-dd"
		case .shortOrdinal: return "EEE dd"
		case .travelDocument: return "MMMM dd yyyy"
		case .hour24: return "HH:mm:ss"
		}
	}
}

extension Date {
	func format(_ style: DateStyle, timeZone: TimeZone? = nil) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = style.format
		dateFormatter.timeZone = timeZone
		return dateFormatter.string(from: self)
	}
	
	func format(_ format: String) -> String {
		let formatter: DateFormatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: self)
	}
	
	var day: Date {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
		if let year = components.year, let month = components.month, let day = components.day {
			var dateComponents = DateComponents()
			dateComponents.year = year
			dateComponents.month = month
			dateComponents.day = day
			return Calendar.current.date(from: dateComponents) ?? self
		}

		return self
	}
}

extension Date {
	func date(byAddingTime time: String) -> Date? {
		let calendar = Calendar.current
		let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)

		let timeFormatter = DateFormatter()
		timeFormatter.dateFormat = "HH:mm:ss"
		guard let startTime = timeFormatter.date(from: time) else {
			return nil
		}
						
		var startTimeComponents = DateComponents()
		startTimeComponents.year = dateComponents.year
		startTimeComponents.month = dateComponents.month
		startTimeComponents.day = dateComponents.day
		startTimeComponents.hour = calendar.component(.hour, from: startTime)
		startTimeComponents.minute = calendar.component(.minute, from: startTime)
		startTimeComponents.second = calendar.component(.second, from: startTime)		
		return calendar.date(from: startTimeComponents)
	}
	
	var startOfDay: Date {
		Calendar.current.startOfDay(for: self)
	}
	
	var endOfDay: Date {
		endOfDay()
	}
    
    var dayName: String {
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateStyle.dayName.format
        let dayName = dateFormatter.string(from: date)
        return dayName
    }
	
	func endOfDay(_ days: Int = 1) -> Date {
		let startOfDay = Calendar.current.startOfDay(for: self)
		guard let endOfDay = Calendar.current.date(byAdding: .day, value: days, to: startOfDay) else {
			return .now
		}
		
		return Calendar.current.date(byAdding: .second, value: -1, to: endOfDay) ?? .now
	}
}
