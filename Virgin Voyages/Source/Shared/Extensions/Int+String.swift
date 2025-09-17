//
//  Int+String.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 22.11.24.
//

import Foundation

extension Int {
    func toHoursAndMinutesString() -> String {
        let hours = self / 60
        let minutes = self % 60
        
        var result = ""
        
        if hours > 0 {
            result += "\(hours) hour" + (hours > 1 ? "s" : "")
        }
        
        if minutes > 0 {
            if !result.isEmpty {
                result += " and "
            }
            result += "\(minutes) minute" + (minutes > 1 ? "s" : "")
        }
        
        return result.isEmpty ? "0 minutes" : result
    }
    
    func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self) / 1000)
    }

	var stringValue: String {
		return "\(self)"
	}
    
    func toTimeWithUTCOffsetInMinutes() -> String {
        
        if self != -1 {

            let utcNow = Date()
            
            let adjustedUtcTime = Calendar.current.date(byAdding: .minute, value: self, to: utcNow)!
            
            return adjustedUtcTime.toHourMinuteDeviceTimeLowercaseMeridiem()
            
        } else {
            
            return ""
            
        }
    }
}
