//
//  PaymentMethodSelectionPages.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class PaymentMethodSelectionPages {
	var paymentInfoModal: PaymentInfoModal
	var question: String
	var imageURL: String

	init(paymentInfoModal: PaymentInfoModal, question: String, imageURL: String) {
		self.paymentInfoModal = paymentInfoModal
		self.question = question
		self.imageURL = imageURL
	}
}
