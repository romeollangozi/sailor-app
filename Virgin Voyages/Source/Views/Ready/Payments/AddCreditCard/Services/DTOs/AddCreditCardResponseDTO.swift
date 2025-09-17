//
//  AddCreditCardResponseDTO.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 7/26/24.
//

import Foundation

struct AddCreditCardResponseDTO: Codable {
	let source: String
	let statusCode: Int
	let status: String
	let details: String
    let ccDetails: CCDetailsDTO?
}

struct CCDetailsDTO: Codable {
    var paymentModeCode: String
    var cardMaskedNo: String
    var cardType: String
    var firstName: String?
    var lastName: String?
    var cardExpiry: String?
}

extension AddCreditCardResponseDTO {
	func toAddCreditCardResponse() -> AddCreditCardResponse {
		
		let cardDetails = ccDetails.flatMap({
			CreditCardDetails(
				paymentMethodCode: $0.paymentModeCode,
				maskedCardNumber: $0.cardMaskedNo,
				cardType: $0.cardType,
				firstName: $0.firstName ?? "",
				lastName: $0.lastName ?? "",
				cardExpiry: $0.cardExpiry ?? ""
			)
		})
		
		return AddCreditCardResponse(source: source,
                                     statusCode: statusCode,
                                     status: status,
                                     details: details,
									 cardDetails: cardDetails)
	}
}
