//
//  ShipsideBookingReferenceDetails.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/30/24.
//

import Foundation

class ShipsideBookingReferenceDetails {
	let lastName: String
	let cabinNumber: String
	let dateOfBirth: Date

	init(lastName: String, cabinNumber: String, dateOfBirth: Date) {
		self.lastName = lastName
		self.cabinNumber = cabinNumber
		self.dateOfBirth = dateOfBirth
	}
}
