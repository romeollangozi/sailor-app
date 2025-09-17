//
//  PaymentMethodPickerPaymentMethodViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/8/24.
//

import Foundation

struct PaymentMethodPickerPaymentMethodViewModel: PaymentMethodPickerPaymentMethodViewModelProtocol {
	var name: String

	init(name: String) {
		self.name = name
	}
}
