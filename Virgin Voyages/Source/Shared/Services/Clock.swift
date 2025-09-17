//
//  Clock.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 22.11.24.
//

import Foundation

protocol ClockProtocol {
    func now() -> Date
    func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date
    func createDate(year: Int, month: Int, day: Int) -> Date
}

struct Clock : ClockProtocol {
	func now() -> Date {
		Date()
	}
	
	func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0) -> Date {
		var dateComponents = DateComponents()
		dateComponents.year = year
		dateComponents.month = month
		dateComponents.day = day
		dateComponents.hour = hour
		dateComponents.minute = minute
		dateComponents.second = second
		
		return Calendar.current.date(from: dateComponents) ?? Date()
	}
	
	func createDate(year: Int, month: Int, day: Int) -> Date {
		var dateComponents = DateComponents()
		dateComponents.year = year
		dateComponents.month = month
		dateComponents.day = day
		
		return Calendar.current.date(from: dateComponents) ?? Date()
	}
}


struct MockClock: ClockProtocol {
    var mockNow: Date = Date()
    var mockCreateDate: ((Int, Int, Int, Int, Int, Int) -> Date)?
    
    func now() -> Date {
        return mockNow
    }
    
    func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
        if let mockCreateDate = mockCreateDate {
            return mockCreateDate(year, month, day, hour, minute, second)
        }
        
        // Default behavior using `Calendar`
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        return Calendar.current.date(from: components) ?? Date()
    }
	
	func createDate(year: Int, month: Int, day: Int) -> Date {
		var dateComponents = DateComponents()
		dateComponents.year = year
		dateComponents.month = month
		dateComponents.day = day
		
		return Calendar.current.date(from: dateComponents) ?? Date()
	}
}
