//
//  PaymentMethodDependentPickerViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/10/24.
//

import Foundation

@Observable class PaymentMethodDependentPickerViewModel {

	var paymentMethodModel: PaymentMethodModel
	var expanded: Bool = false

	var dependentTitle: String {
		return paymentMethodModel.dependentsSection.dependentTitle
	}

	var pendingPaymentDependentDescription: String {
		return paymentMethodModel.dependentsSection.pendingPaymentDependentDescription
	}

	var completedPaymentDependentDescription: String {
		return paymentMethodModel.dependentsSection.completedPaymentDependentDescription
	}

	var shouldShowCompletedPaymentDependentSection: Bool {
		return paymentMethodModel.numberOfPartyMemberWithPayment > 0
	}

	init(paymentMethodModel: PaymentMethodModel) {
		self.paymentMethodModel = paymentMethodModel
	}
}
