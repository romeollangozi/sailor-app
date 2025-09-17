//
//  TestUtilities.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 26.6.25.
//

import Foundation

func createUTCDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    dateComponents.hour = hour
    dateComponents.minute = minute
    dateComponents.second = second

    var calendar = Calendar.current
    calendar.timeZone = TimeZone(secondsFromGMT: 0)! // UTC

    return calendar.date(from: dateComponents) ?? Date()
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
