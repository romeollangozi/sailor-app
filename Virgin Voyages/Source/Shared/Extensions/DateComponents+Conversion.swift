//
//  DateComponents+Conversion.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.9.24.
//

import Foundation

extension DateComponents {
    func toFormattedString(format: String = "yyyy-MM-dd") -> String? {
        let calendar = Calendar.current
        guard let date = calendar.date(from: self) else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}
