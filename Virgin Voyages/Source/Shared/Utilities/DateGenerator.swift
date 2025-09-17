//
//  DateGenerator.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 4.12.24.
//

import Foundation

class DateGenerator {
    public static func generateDates(from: Date, totalDays: Int) -> [Date] {
        return (0..<totalDays).map { Calendar.current.date(byAdding: .day, value: $0, to: from)! }
    }
}
