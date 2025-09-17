//
//  MealTime.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 2/3/24.
//

import Foundation

enum MealTime: String, Identifiable, CaseIterable, CustomStringConvertible {
	case brunch
	case dinner
	
	var id: String {
		rawValue
	}
	
	var bookingType: String {
		switch self {
		case .brunch: return "BF"
		case .dinner: return "DN"
		}
	}
	
	var mealPeriod: String {
		switch self {
		case .brunch: return "BRUNCH"
		case .dinner: return "DINNER"
		}
	}
	
	var description: String {
		switch self {
		case .brunch: return "Brunch"
		case .dinner: return "Dinner"
		}
	}
	
	init(date: Date) {
		let morning: MealTime = .brunch
		guard let start = morning.startTime(in: date) else {
			self = .dinner
			return
		}
		
		guard let end = morning.endTime(in: date) else {
			self = .dinner
			return
		}
		
		let range = start...end
		self = range.contains(date) ? .brunch : .dinner
	}
	
	func startTime(in day: Date) -> Date? {
		let calendar = Calendar.current
		var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: day)
		switch self {
		case .brunch:
			components.hour = 6
			components.minute = 0
			return calendar.date(from: components)
			
		case .dinner:
			components.hour = 12 + 5
			components.minute = 0
			return calendar.date(from: components)
		}
	}
	
	func endTime(in day: Date) -> Date? {
		let calendar = Calendar.current
		var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: day)
		switch self {
		case .brunch:
			components.hour = 12 + 1
			components.minute = 0
			return calendar.date(from: components)
			
		case .dinner:
			components.hour = 12 + 10
			components.minute = 0
			return calendar.date(from: components)
		}
	}

	func dateRange(day: Date) -> ClosedRange<Date>? {
		guard let start = startTime(in: day) else {
			return nil
		}
		
		guard let end = endTime(in: day) else { // day
			return nil
		}
		
		guard start <= end else {
			return nil
		}
		
		return start...end
	}
	
	func dateRange(day: Date, shipTime: Date) -> ClosedRange<Date>? {
		let range = dateRange(day: day)
		
		if let start = range?.lowerBound, let end = range?.upperBound, start < shipTime {
			if shipTime > end {
				return nil
			}
			
			return shipTime...end
		}
		
		return range
	}
}
