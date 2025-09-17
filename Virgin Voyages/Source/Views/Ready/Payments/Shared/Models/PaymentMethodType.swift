//
//  PaymentMethodType.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

enum PaymentMethodType: String, Identifiable {
	case creditCard = "9ef030f9-e5c1-e611-80c5-00155df80332"
	case cash = "02ee248e-e3d5-4242-8c99-94a51608a63d"
	case someoneElse = "f8205196-993b-11e7-adc9-0a1a4261e962"

	var id: String {
		rawValue
	}
}
