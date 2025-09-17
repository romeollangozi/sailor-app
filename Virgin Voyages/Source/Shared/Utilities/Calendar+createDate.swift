//
//  Calendar+createDate.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/18/25.
//

import Foundation

func createDate<T: Numeric & LosslessStringConvertible>(from components: [T]) -> Date? {
    guard components.count == 3,
          let year = Double(String(components[0])).flatMap(Int.init),
          let month = Double(String(components[1])).flatMap(Int.init),
          let day = Double(String(components[2])).flatMap(Int.init) else {
        return nil
    }
    
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    dateComponents.hour = 0
    dateComponents.minute = 0
    dateComponents.second = 0
    
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    
    return calendar.date(from: dateComponents)
}
