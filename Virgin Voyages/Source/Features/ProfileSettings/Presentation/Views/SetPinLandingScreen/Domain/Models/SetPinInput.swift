//
//  SetPinInput.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 21.7.25.
//

struct SetPinInput {
	let pin: String
	let reservationGuestId: String
}

extension SetPinInput {
	func toRequestBody() -> SetPinRequestBody {
		return SetPinRequestBody(reservationGuestId: self.reservationGuestId, pin: pin)
	}
}
