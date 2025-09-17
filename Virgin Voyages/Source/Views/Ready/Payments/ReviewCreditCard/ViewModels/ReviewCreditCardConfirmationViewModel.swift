//
//  ReviewCreditCardConfirmationViewModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/16/24.
//

import SwiftUI

@Observable class ReviewCreditCardConfirmationViewModel: ReviewCreditCardConfirmationViewModelProtocol {

	var paymentMethodModel: PaymentMethodModel

	var cardNumber: String {
		return self.paymentMethodModel.savedCards.first?.maskedNumber ?? ""
	}

	var name: String {
		return self.paymentMethodModel.savedCards.first?.name ?? ""
	}

	var expiryMonth: String {
		return self.paymentMethodModel.savedCards.first?.expiryMonth ?? ""
	}

	var expiryYear: String {
		return self.paymentMethodModel.savedCards.first?.expiryYear ?? ""
	}

	init(paymentMethodModel: PaymentMethodModel) {
		self.paymentMethodModel = paymentMethodModel
	}
}
