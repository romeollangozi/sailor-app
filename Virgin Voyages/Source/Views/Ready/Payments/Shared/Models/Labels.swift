//
//  Labels.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class Labels {
	var expiry: String
	var cardNumber: String
	var zip: String
	var cvv: String
	var name: String

	init(expiry: String, cardNumber: String, zip: String, cvv: String, name: String) {
		self.expiry = expiry
		self.cardNumber = cardNumber
		self.zip = zip
		self.cvv = cvv
		self.name = name
	}
}
