//
//  Sailing.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/17/23.
//

import Foundation

extension Double {
	var priceText: String {
		let formatter = NumberFormatter()
		formatter.locale = Locale.current
		formatter.numberStyle = .currency
		formatter.minimumFractionDigits = (self.truncatingRemainder(dividingBy: 1) == 0) ? 0 : 2
		return formatter.string(from: NSNumber(value: self)) ?? ""
	}
	
	var priceDecimalText: String {
		let formatter = NumberFormatter()
		formatter.locale = Locale.current
		formatter.numberStyle = .currency
		formatter.minimumFractionDigits = 2
		return formatter.string(from: NSNumber(value: self)) ?? ""
	}

	var priceIntegerPartText: String {
		let integerPart = Int(self)
		let formatter = NumberFormatter()
		formatter.locale = Locale.current
		formatter.numberStyle = .decimal
		return formatter.string(from: NSNumber(value: integerPart)) ?? ""
	}

	var priceDecimalPartText: String {
		let decimalPart = abs(self - Double(Int(self)))
		let decimalString = String(format: "%.2f", decimalPart).dropFirst() // remove the "0" before "."
		return String(decimalString)
	}

	func priceText(currencyCode: CurrencyCode) -> String {
		let formatter = NumberFormatter()
		formatter.locale = Locale.current
		formatter.numberStyle = .currency
		formatter.currencyCode = currencyCode // currencyCode.rawValue
		formatter.minimumFractionDigits = (self.truncatingRemainder(dividingBy: 1) == 0) ? 0 : 2
		return formatter.string(from: NSNumber(value: self)) ?? ""
	}
}
