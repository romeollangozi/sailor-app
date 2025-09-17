//
//  ShoresideBookingReferenceDetailsDTO.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/29/24.
//

import Foundation

class ShoresideBookingReferenceDetailsDTO: Codable {
	let lastName: String
	let bookingReferenceNumber: String
	let dateOfBirth: Date
	let sailDate: Date

	init(lastName: String, bookingReferenceNumber: String, dateOfBirth: Date, sailDate: Date) {
		self.lastName = lastName
		self.bookingReferenceNumber = bookingReferenceNumber
		self.dateOfBirth = dateOfBirth
		self.sailDate = sailDate
	}
}
