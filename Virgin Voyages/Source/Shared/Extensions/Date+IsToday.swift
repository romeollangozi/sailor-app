//
//  Date+IsToday.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 3/13/25.
//


import Foundation

extension Date {
	var isToday: Bool {
		return Calendar.current.isDate(self, inSameDayAs: Date())
	}
}
