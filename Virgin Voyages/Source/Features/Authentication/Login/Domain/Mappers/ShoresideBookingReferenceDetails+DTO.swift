//
//  ShoresideBookingReferenceDetails+DTO.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/29/24.
//

import Foundation

extension ShoresideBookingReferenceDetails {
	func toDTO() -> ShoresideBookingReferenceDetailsDTO {
		return ShoresideBookingReferenceDetailsDTO(lastName: lastName,
												   bookingReferenceNumber: bookingReferenceNumber,
												   dateOfBirth: dateOfBirth,
												   sailDate: sailDate)
	}
}
