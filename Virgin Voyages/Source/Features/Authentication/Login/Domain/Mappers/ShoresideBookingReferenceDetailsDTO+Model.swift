//
//  ShoresideBookingReferenceDetailsDTO+Model.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/29/24.
//

import Foundation

extension ShoresideBookingReferenceDetailsDTO {
	func toModel() -> ShoresideBookingReferenceDetails {
		return ShoresideBookingReferenceDetails(lastName: lastName,
												bookingReferenceNumber: bookingReferenceNumber,
												dateOfBirth: dateOfBirth,
												sailDate: sailDate)
	}
}
