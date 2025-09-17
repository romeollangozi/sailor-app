//
//  ClaimBooking.swift
//  Virgin Voyages
//
//  Created by TX on 14.7.25.
//

struct ClaimBooking {
	enum Status {
		case success
		case bookingNotFound
		case emailConflict
		case guestConflict
		case unknown
	}

	let status: Status
	let guestDetails: [ClaimBookingGuestDetails]
}
