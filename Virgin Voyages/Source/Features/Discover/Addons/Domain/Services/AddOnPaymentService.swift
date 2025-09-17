//
//  AddOnPaymentService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/28/24.
//

import Foundation

enum AddOnPaymentResult {
	case approved
	case declined
}

protocol AddOnPaymentServiceProtocol {
	func payAddOnWithExistingCard(reservationNumber: String,
								  guestIds: [String],
							code: String,
							quantity: Int,
							currencyCode: String,
							amount: String,
							guestUniqueId: String) async -> AddOnPaymentResult

	func fetchPaymentURL(reservationNumber: String,
						 guestIds: [String],
						 code: String,
						 quantity: Int,
						 currencyCode: String,
						 amount: String,
						 guestUniqueId: String) async  -> AddOnPaymentResponse?
}

class AddOnPaymentService: AddOnPaymentServiceProtocol {

	func payAddOnWithExistingCard(reservationNumber: String,
								  guestIds: [String],
							code: String,
							quantity: Int,
							currencyCode: String,
							amount: String,
							guestUniqueId: String) async -> AddOnPaymentResult {
		let response = await NetworkService.create().payAddOnWithExistingCard(reservationNumber: reservationNumber,
																			  guestIds: guestIds,
																			  code: code,
																			  quantity: quantity,
																			  currencyCode: currencyCode,
																			  amount: amount,
																			  guestUniqueId: guestUniqueId)

		guard let response = response else { return .declined }
		if case .success = response {
			return .approved
		} else {
			return .declined
		}
	}

	func fetchPaymentURL(reservationNumber: String,
						 guestIds: [String],
						 code: String,
						 quantity: Int,
						 currencyCode: String,
						 amount: String,
						 guestUniqueId: String) async -> AddOnPaymentResponse? {
		let response = await NetworkService.create().fetchAddOnPaymentPage(reservationNumber: reservationNumber,
																		   guestIds: guestIds,
																		   code: code,
																		   quantity: quantity,
																		   currencyCode: currencyCode,
																		   amount: amount,
																		   guestUniqueId: guestUniqueId)
		return response
	}
}
