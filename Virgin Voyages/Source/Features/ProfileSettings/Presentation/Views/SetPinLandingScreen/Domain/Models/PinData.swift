//
//  PinData.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.7.25.
//


struct PinData: Equatable {
	public let digits: [String]

	public var value: String {
		digits.joined()
	}

	public var isComplete: Bool {
		digits.count == 4
	}

	public var isEmpty: Bool {
		digits.isEmpty
	}

	public static var empty: PinData {
		PinData(digits: [])
	}

	public init(from string: String) {
		let filtered = string.filter(\.isNumber)
		let limitedString = String(filtered.prefix(4))
		self.digits = limitedString.map(String.init)
	}

	public init(digits: [String]) {
		self.digits = Array(digits.prefix(4))
	}
}
