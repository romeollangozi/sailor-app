//
//  SavedCard.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/22/24.
//

import Foundation

class SavedCard {
	var expiryYear: String
	var receiptReference: String
	var zipcode: String
	var paymentToken: String
	var maskedNumber: String
	var billToCity: String
	var billToLine1: String
	var billToLine2: String
	var shipToCity: String
	var shipToFirstName: String
	var shipToLastName: String
	var name: String
	var billToState: String
	var type: String
	var billToFirstName: String
	var billToLastName: String
	var billToZipCode: String
	var shipToLine1: String
	var shipToLine2: String
	var tokenProvider: String
	var shipToZipCode: String
	var expiryMonth: String
	var shipToState: String

	public init(
		expiryYear: String = "",
		receiptReference: String = "",
		zipcode: String = "",
		paymentToken: String = "",
		maskedNumber: String = "",
		billToCity: String = "",
		billToLine1: String = "",
		billToLine2: String = "",
		shipToCity: String = "",
		shipToFirstName: String = "",
		shipToLastName: String = "",
		name: String = "",
		billToState: String = "",
		type: String = "",
		billToFirstName: String = "",
		billToLastName: String = "",
		billToZipCode: String = "",
		shipToLine1: String = "",
		shipToLine2: String = "",
		tokenProvider: String = "",
		shipToZipCode: String = "",
		expiryMonth: String = "",
		shipToState: String = ""
	) {
		self.expiryYear = expiryYear
		self.receiptReference = receiptReference
		self.zipcode = zipcode
		self.paymentToken = paymentToken
		self.maskedNumber = maskedNumber
		self.billToCity = billToCity
		self.billToLine1 = billToLine1
		self.billToLine2 = billToLine2
		self.shipToCity = shipToCity
		self.shipToFirstName = shipToFirstName
		self.shipToLastName	= shipToLastName
		self.name = name
		self.billToState = billToState
		self.type = type
		self.billToFirstName = billToFirstName
		self.billToLastName = billToLastName
		self.billToZipCode = billToZipCode
		self.shipToLine1 = shipToLine1
		self.shipToLine2 = shipToLine2
		self.tokenProvider = tokenProvider
		self.shipToZipCode = shipToZipCode
		self.expiryMonth = expiryMonth
		self.shipToState = shipToState
	}
}
