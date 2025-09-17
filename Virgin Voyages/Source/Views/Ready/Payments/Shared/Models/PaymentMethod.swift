//
//  PaymentMethod.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class PaymentMethod {
	var name: String
	var type: PaymentMethodType

	init(name: String, type: PaymentMethodType) {
		self.name = name
		self.type = type
	}
}
