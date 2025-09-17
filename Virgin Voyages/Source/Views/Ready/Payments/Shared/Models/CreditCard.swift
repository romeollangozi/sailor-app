//
//  CreditCard.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class CreditCard {
	var cardMaskedNo: String
	var cardType: String
	var cardExpiryMonth: String
	var cardExpiryYear: String
	var paymentToken: String
	var name: String
	var zipcode: String

	init(cardMaskedNo: String, cardType: String, cardExpiryMonth: String, cardExpiryYear: String, paymentToken: String, name: String, zipcode: String) {
		self.cardMaskedNo = cardMaskedNo
		self.cardType = cardType
		self.cardExpiryMonth = cardExpiryMonth
		self.cardExpiryYear = cardExpiryYear
		self.paymentToken = paymentToken
		self.name = name
		self.zipcode = zipcode
	}
}
