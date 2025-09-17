//
//  ShipsideBookingReferenceDetails+DTO.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/30/24.
//

import Foundation

extension ShipsideBookingReferenceDetails {
	func toDTO() -> ShipsideBookingReferenceDetailsDTO {
		return ShipsideBookingReferenceDetailsDTO(lastName: lastName,
												  cabinNumber: cabinNumber,
												  dateOfBirth: dateOfBirth)
	}
}
