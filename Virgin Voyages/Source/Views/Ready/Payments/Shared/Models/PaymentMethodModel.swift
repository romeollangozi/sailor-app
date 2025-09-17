//
//  PaymentMethodModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/5/24.
//

import Foundation

class PaymentMethodModel {
	var buttons: Buttons
	var cashDepositPages: CashDepositPages
	var updateURL: String
	var dependentsSection: DependentsSection
	var creditCardPages: CreditCardPages
	var paymentMethodSelectionPages: PaymentMethodSelectionPages
	var availablePaymentMethods: [PaymentMethod]
	var paymentDetails: PaymentDetails
	var someoneElsePages: SomeoneElsePages
	var dependents: [Dependent]
    var savedCards: [SavedCard]

	init(buttons: Buttons,
		 cashDepositPages: CashDepositPages,
		 updateURL: String,
		 dependentsSection: DependentsSection,
		 creditCardPages: CreditCardPages,
		 paymentMethodSelectionPages: PaymentMethodSelectionPages,
		 availablePaymentMethods: [PaymentMethod],
		 paymentDetails: PaymentDetails,
		 someoneElsePages: SomeoneElsePages,
         dependents: [Dependent],
         savedCards: [SavedCard]) {
		self.buttons = buttons
		self.cashDepositPages = cashDepositPages
		self.updateURL = updateURL
		self.dependentsSection = dependentsSection
		self.creditCardPages = creditCardPages
		self.paymentMethodSelectionPages = paymentMethodSelectionPages
		self.availablePaymentMethods = availablePaymentMethods
		self.paymentDetails = paymentDetails
		self.someoneElsePages = someoneElsePages
		self.dependents = dependents
        self.savedCards = savedCards
	}

	var numberOfPartyMemberWithPayment: Int {
		paymentDetails.partyMembers.reduce(0) { count, partyMember in
			partyMember.isPaymentMethodAlreadySet ? count + 1 : count
		}
	}

	func partyMemberWithoutPayment(dependent: Dependent) -> PartyMember? {
		paymentDetails.partyMembers.first {
			!$0.isPaymentMethodAlreadySet && $0.reservationGuestId == dependent.id
		}
	}

	func partyMemberWithPayment(dependent: Dependent) -> PartyMember? {
		paymentDetails.partyMembers.first {
			$0.isPaymentMethodAlreadySet && $0.reservationGuestId == dependent.id
		}
	}
}
