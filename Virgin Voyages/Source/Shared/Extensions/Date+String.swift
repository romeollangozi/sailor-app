//
//  Date+String.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/10/24.
//

import Foundation

extension Date {
	
	func toHourMinute() -> String {
		toStringWithTimeZone(to: "h:mm a")
	}
	
	func toUSDateFormat() -> String {
		toStringWithTimeZone(to: "MM/dd/yyyy")
	}

	func toHourMinuteDeviceTimeLowercaseMeridiem(timeZone: TimeZone? = nil) -> String {
		toStringWithTimeZone(to: "h:mma", timeZone: timeZone)
	}

    func toYearMMdd() -> String {
		toStringWithTimeZone(to: "yyyy-MM-dd")
    }
    
    func toMonthDayYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func toMonthDDYYY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func toISO8601() -> String {
		toStringWithTimeZone(to: "yyyy-MM-dd'T'HH:mm:ss")
    }

    func weekdayName() -> String {
		toStringWithTimeZone(to: "EEEE")
    }

    func toDayMonthDayTime() -> String {
		toStringWithTimeZone(to: "E MMMM d, h:mma")
    }
    
    func toMonthDayTime() -> String {
        toStringWithTimeZone(to: "MMMM d - h:mma")
    }
	
    func toDayMonthDayNumber() -> String {
		toStringWithTimeZone(to: "EEEE, MMMM d")
    }
    
    func toDayWithOrdinal() -> String {
		let formatter = createFormatterWithTimeZone()
        formatter.dateFormat = "EEE d'suffix'"
            
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        
        let ordinal: String
        switch day % 10 {
        case 1 where day != 11: ordinal = "st"
        case 2 where day != 12: ordinal = "nd"
        case 3 where day != 13: ordinal = "rd"
        default: ordinal = "th"
        }
        
        return formatter.string(from: self).replacingOccurrences(of: "suffix", with: ordinal)
    }
    
    func toLetter() -> String {
		toStringWithTimeZone(to: "E")
    }
    
    func toDayNumber() -> String {
		toStringWithTimeZone(to: "d")
    }
    
    func toFullDateTimeWithOrdinal() -> String {
		let formatter = createFormatterWithTimeZone()
		formatter.dateFormat = "EEEE d'suffix' h:mma"
		
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        
        let ordinal: String
        switch day % 10 {
			case 1 where day != 11: ordinal = "st"
			case 2 where day != 12: ordinal = "nd"
			case 3 where day != 13: ordinal = "rd"
			default: ordinal = "th"
        }
        
        return formatter.string(from: self).replacingOccurrences(of: "suffix", with: ordinal)
    }
    
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 30 * day
        
        let quotient: Int
        let unit: String
        
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "minute"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
    
    func dayAndTimeFormattedString() -> String {
		toStringWithTimeZone(to: "EEE, h:mma")
    }
    
    func shortWeekdayFullMonthDayTime() -> String {
		toStringWithTimeZone(to: "EEE MMMM d, h:mm a")
    }
	
	func toWeekdayDay() -> String {
		toStringWithTimeZone(to: "EEEE dd")
	}
    
    func timeAgoString() -> String {
        let now = Date()
        let secondsAgo = Int(now.timeIntervalSince(self))

        switch secondsAgo {
        case ..<60:
            return "now"
        case 60..<3600:
            return "\(secondsAgo / 60) min"
        case 3600..<86400:
            return "\(secondsAgo / 3600)h"
        case 86400..<172800:
            return "1 day"
        default:
            return "\(secondsAgo / 86400) days"
        }
    }
	
	private func toStringWithTimeZone(to format: String, timeZone: TimeZone? = nil) -> String {
		let dateFormatter = createFormatterWithTimeZone(timeZone: timeZone)
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self)
	}
	
	private func createFormatterWithTimeZone(timeZone: TimeZone? = nil) -> DateFormatter {
		let dateFormatter = DateFormatter()
		
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = timeZone ?? TimeZone(secondsFromGMT: 0)
		dateFormatter.amSymbol = "am"
		dateFormatter.pmSymbol = "pm"
		
		return dateFormatter
	}
}
