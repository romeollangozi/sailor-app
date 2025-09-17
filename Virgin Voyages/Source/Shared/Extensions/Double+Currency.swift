//
//  Double+Currency.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 27.9.24.
//

import Foundation

extension Double {
    func toCurrency() -> String {
        return String(format: "%.2f", self)
    }
}
