//
//  PaymentDetails.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class PaymentDetails {
	var partyMembers: [PartyMember]
	var selectedPaymentMethodType: PaymentMethodType?
	var cardDetails: [CreditCard]

	init(partyMembers: [PartyMember], selectedPaymentMethodType: PaymentMethodType?, cardDetails: [CreditCard]) {
		self.partyMembers = partyMembers
		self.selectedPaymentMethodType = selectedPaymentMethodType
		self.cardDetails = cardDetails
	}
}
