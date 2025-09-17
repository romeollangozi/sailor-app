//
//  ShipsideBookingReferenceDetailsDTO+Model.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/30/24.
//

import Foundation

extension ShipsideBookingReferenceDetailsDTO {
	func toModel() -> ShipsideBookingReferenceDetails {
		return ShipsideBookingReferenceDetails(lastName: lastName,
											   cabinNumber: cabinNumber,
											   dateOfBirth: dateOfBirth)
	}
}
