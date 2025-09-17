//
//  CreateCabinServiceRequestInput.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//

struct CreateCabinServiceRequestInput: Equatable {
	let reservationId: String
	let reservationGuestId: String
	let guestId: String
	let cabinNumber: String
	let requestName: String
}
