//
//  Date+Validation.swift
//  Virgin Voyages
//
//  Created by TX on 6.12.24.
//

import Foundation

extension Date {
    func isWithinMonths(_ months: Int, of otherDate: Date) -> Bool {
        let calendar = Calendar.current
        
        // Calculate the difference in months
        if let differenceInMonths = calendar.dateComponents([.month], from: self, to: otherDate).month {
            return abs(differenceInMonths) < months
        }
        return false
    }
}

