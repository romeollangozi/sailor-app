//
//  String+Masking.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/28/25.
//

import Foundation

enum MaskingRule {
	case partialPrefix       // e.g. Si****, Su****
	case hideYear            // e.g. Aug 28, ****
}

extension String {
	/// Masks each word keeping the first character and replacing the rest with "*"
	func maskedByWord() -> String {
		return self.split(separator: " ").map { word in
			guard let first = word.first else { return "" }
			let stars = String(repeating: "*", count: word.count - 1)
			return "\(first)\(stars)"
		}.joined(separator: " ")
	}
	
	/// Masks the entire string with "*" matching the number of characters
	func fullyMasked() -> String {
		return String(repeating: "*", count: self.count)
	}
	
	func maskedExceptLastFour() -> String {
		guard self.count > 4 else { return String(repeating: "*", count: self.count) }
		let maskCount = self.count - 4
		let maskedPart = String(repeating: "*", count: maskCount)
		let visiblePart = self.suffix(4)
		return maskedPart + visiblePart
	}

	func masked(as rule: MaskingRule) -> String {
		switch rule {
		case .partialPrefix:
			return self.maskWithPrefix()
		case .hideYear:
			return self.maskYearFromDate()
		}
	}

	private func maskWithPrefix() -> String {
		guard self.count > 2 else {
			return self + String(repeating: "*", count: max(0, 5 - self.count))
		}
		let prefix = self.prefix(2)
		let maskedPart = String(repeating: "*", count: self.count - 2)
		return prefix + maskedPart
	}

	private func maskYearFromDate() -> String {
		let inputFormatter = DateFormatter()
		inputFormatter.dateFormat = "MMM dd, yyyy"
		inputFormatter.locale = Locale(identifier: "en_US_POSIX")

		guard let date = inputFormatter.date(from: self) else {
			return ""
		}

		let outputFormatter = DateFormatter()
		outputFormatter.dateFormat = "MMM dd"
		return outputFormatter.string(from: date) + ", ****"
	}
}
