//
//  Date+isDateEarlierToOffset.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 30.6.25.
//

import Foundation

public func isDateEarlierThanOffset(_ date: Date, months: Int, from referenceDate: Date) -> Bool {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!

    guard let thresholdDate = calendar.date(byAdding: .month, value: months, to: referenceDate) else {
        return false
    }

    return calendar.compare(date, to: thresholdDate, toGranularity: .day) == .orderedAscending
}
