//
//  Calendar+Validation.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 28.11.24.
//

import Foundation

extension Calendar {
    func isDateInPast(_ date: Date) -> Bool {
        let currentDay = self.startOfDay(for: Date())
        let comparisonDay = self.startOfDay(for: date)
        return comparisonDay < currentDay
    }
}
