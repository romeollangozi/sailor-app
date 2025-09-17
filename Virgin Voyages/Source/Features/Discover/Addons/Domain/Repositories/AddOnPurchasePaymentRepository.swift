//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/22/24.
//

import Foundation

protocol PaymentRepositoryProtocol {
	func fetchSavedCards() async -> [SavedCard]
}

class PaymentRepository: PaymentRepositoryProtocol {
	func fetchSavedCards() async -> [SavedCard] {
		let response = await NetworkService.create().fetchPaymentMethods()
		let savedCards = response?.savedCards.map({
			SavedCard(
				expiryYear: $0.cardExpiryYear ?? "",
				zipcode: $0.zipcode ?? "",
				paymentToken: $0.paymentToken ?? "",
				maskedNumber: $0.cardMaskedNo ?? "",
				name: $0.name ?? "",
				type: $0.cardType ?? "",
				expiryMonth: $0.cardExpiryMonth ?? ""
			)
		})
		return savedCards ?? []
	}
}
