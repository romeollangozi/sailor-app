//
//  DoublePriceTests.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/28/25.
//

import XCTest
@testable import Virgin_Voyages

final class PriceFormattingTests: XCTestCase {

	func testPriceText() {
		XCTAssertEqual(12.0.priceText, localizedCurrencyString(for: 12.0, minFractionDigits: 0))
		XCTAssertEqual(12.34.priceText, localizedCurrencyString(for: 12.34, minFractionDigits: 2))
		XCTAssertEqual(0.0.priceText, localizedCurrencyString(for: 0.0, minFractionDigits: 0))
		XCTAssertEqual(9999.99.priceText, localizedCurrencyString(for: 9999.99, minFractionDigits: 2))
	}

	func testPriceDecimalText() {
		XCTAssertEqual(12.0.priceDecimalText, localizedCurrencyString(for: 12.0, minFractionDigits: 2))
		XCTAssertEqual(12.34.priceDecimalText, localizedCurrencyString(for: 12.34, minFractionDigits: 2))
		XCTAssertEqual(0.0.priceDecimalText, localizedCurrencyString(for: 0.0, minFractionDigits: 2))
	}

	func testPriceIntegerPartText() {
		XCTAssertEqual(34.95.priceIntegerPartText, localizedDecimalString(for: 34))
		XCTAssertEqual(99.01.priceIntegerPartText, localizedDecimalString(for: 99))
		XCTAssertEqual(0.99.priceIntegerPartText, localizedDecimalString(for: 0))
		XCTAssertEqual(1000.01.priceIntegerPartText, localizedDecimalString(for: 1000))
	}

	func testPriceDecimalPartText() {
		XCTAssertEqual(34.95.priceDecimalPartText, ".95")
		XCTAssertEqual(99.01.priceDecimalPartText, ".01")
		XCTAssertEqual(0.5.priceDecimalPartText, ".50")
		XCTAssertEqual(1000.0.priceDecimalPartText, ".00")
	}

	func testPriceTextWithCurrencyCode() {
		XCTAssertEqual(12.0.priceText(currencyCode: "USD"), localizedCurrencyString(for: 12.0, currencyCode: "USD", minFractionDigits: 0))
		XCTAssertEqual(12.34.priceText(currencyCode: "EUR"), localizedCurrencyString(for: 12.34, currencyCode: "EUR", minFractionDigits: 2))
		XCTAssertEqual(0.0.priceText(currencyCode: "JPY"), localizedCurrencyString(for: 0.0, currencyCode: "JPY", minFractionDigits: 0))
	}
}

// MARK: - Helpers

private func localizedCurrencyString(for value: Double, currencyCode: String? = nil, minFractionDigits: Int) -> String {
	let formatter = NumberFormatter()
	formatter.locale = Locale.current
	formatter.numberStyle = .currency
	formatter.minimumFractionDigits = minFractionDigits
	if let code = currencyCode {
		formatter.currencyCode = code
	}
	return formatter.string(from: NSNumber(value: value)) ?? ""
}

private func localizedDecimalString(for value: Int) -> String {
	let formatter = NumberFormatter()
	formatter.locale = Locale.current
	formatter.numberStyle = .decimal
	return formatter.string(from: NSNumber(value: value)) ?? ""
}
