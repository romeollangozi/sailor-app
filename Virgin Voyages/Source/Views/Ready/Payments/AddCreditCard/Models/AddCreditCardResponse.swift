//
//  AddCreditCardResponse.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 7/26/24.
//

import Foundation

struct AddCreditCardResponse {
	let source: String
	let statusCode: Int
	let status: String
	let details: String
    let cardDetails: CreditCardDetails?
}

struct CreditCardDetails {
    let paymentMethodCode: String
    let maskedCardNumber: String
    let cardType: String
    let firstName: String
    let lastName: String
    let cardExpiry: String
}
