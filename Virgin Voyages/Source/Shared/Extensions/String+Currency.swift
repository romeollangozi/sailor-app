//
//  String+Currency.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.10.24.
//

import Foundation

extension String {
    var currencySign: String {
        switch self {
        case "CAD":  return "CAD$"
        case "AUD":  return "AUD$"
        case "NZD":  return "NZ$"
        case "EUR":  return "€"
        case "GBP":  return "£"
        case "USD":  return "$"
        default:
            return ""
        }
    }
}
