//
//  Date+Int.swift
//  Virgin Voyages
//
//  Created by TX on 26.11.24.
//

import Foundation

extension Date {
    static func unixTimeNow() -> Int {
        Int(Date().timeIntervalSince1970)
    }
}
