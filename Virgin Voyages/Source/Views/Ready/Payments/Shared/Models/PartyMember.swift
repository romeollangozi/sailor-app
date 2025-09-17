//
//  PartyMember.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/11/24.
//

import Foundation

class PartyMember {
	var reservationGuestId: String
	var name: String
	var imageURL: String
	var genderCode: String
	var isPaymentMethodAlreadySet: Bool
	var isDependent: Bool
	var selectedPaymentMethodType: PaymentMethodType?

	init(reservationGuestId: String,
		 name: String,
		 imageURL: String,
		 genderCode: String,
		 isPaymentMethodAlreadySet: Bool,
		 isDependent: Bool,
		 selectedPaymentMethodType: PaymentMethodType?) {
		self.reservationGuestId = reservationGuestId
		self.name = name
		self.imageURL = imageURL
		self.genderCode = genderCode
		self.isPaymentMethodAlreadySet = isPaymentMethodAlreadySet
		self.isDependent = isDependent
		self.selectedPaymentMethodType = selectedPaymentMethodType
	}
}
