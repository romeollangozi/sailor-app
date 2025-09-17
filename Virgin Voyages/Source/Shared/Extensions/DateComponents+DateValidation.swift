//
//  DateComponents+DateValidation.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/30/24.
//

import Foundation

extension DateComponents {
    
    var isOlderThan16Years: Bool {
        if !self.isFullySpecifiedDate() { return false }
        guard let birthDate = Calendar.current.date(from: self) else {
            return false
        }
        let currentDate = Date()
        let thirteenYearsAgo = Calendar.current.date(byAdding: .year, value: -16, to: currentDate)!
        return birthDate <= thirteenYearsAgo
    }
    
    var dateIsOlderThan16Years: Bool {
        // Other method returns false if the date is not a valid date.
        // What we need is only a boolean that returns false if date 13+ in the past.
        guard let birthDate = Calendar.current.date(from: self) else {
            return true
        }
        let currentDate = Date()
        let thirteenYearsAgo = Calendar.current.date(byAdding: .year, value: -16, to: currentDate)!
        return birthDate <= thirteenYearsAgo
    }
    
	func isValidDate() -> Bool {
		guard let year = self.year, let month = self.month, let day = self.day else {
			return false
		}

		let calendar = Calendar.current
		var dateComponents = DateComponents()
		dateComponents.year = year
		dateComponents.month = month
		dateComponents.day = day

		guard let date = calendar.date(from: dateComponents) else {
			return false
		}

		let validatedComponents = calendar.dateComponents([.year, .month, .day], from: date)

		return validatedComponents.year == year && validatedComponents.month == month && validatedComponents.day == day
	}

	func isFullySpecifiedDate() -> Bool {
		return year != nil && month != nil && day != nil
	}
}
