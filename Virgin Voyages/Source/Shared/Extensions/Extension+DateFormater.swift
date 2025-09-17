//
//  Extension+DateFormater.swift
//  Virgin Voyages
//
//  Created by Pajtim on 29.8.25.
//

import Foundation

extension DateFormatter {
    static func createTimeParser() -> DateFormatter {
        let parser = DateFormatter()
        parser.dateFormat = "h:mma"
        parser.amSymbol = "AM"
        parser.pmSymbol = "PM"
        parser.locale = .current
        return parser
    }
}
