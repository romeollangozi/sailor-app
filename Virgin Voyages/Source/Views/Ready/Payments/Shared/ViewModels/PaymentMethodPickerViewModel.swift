//
//  PaymentMethodPickerViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/8/24.
//

import Foundation

struct PaymentMethodPickerViewModel: PaymentMethodPickerViewModelProtocol {
	var availablePaymentMethods: [PaymentMethodPickerPaymentMethodViewModelProtocol]

	init(availablePaymentMethods: [PaymentMethodPickerPaymentMethodViewModelProtocol]) {
		self.availablePaymentMethods = availablePaymentMethods
	}
}
