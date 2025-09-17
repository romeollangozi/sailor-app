//
//  BookableConflicts.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 11.3.25.
//


import Foundation

struct BookableConflicts: Hashable {
	let slotId: String
	let slotStatus: ConflictState
	let sailors: [Sailor]

	struct Sailor: Hashable {
		let reservationGuestId: String
		let status: ConflictState
		let bookableType: BookableType
		let appointmentId: String?
		
		init(reservationGuestId: String, status: ConflictState, bookableType: BookableType, appointmentId: String? = nil) {
			self.reservationGuestId = reservationGuestId
			self.status = status
			self.bookableType = bookableType
			self.appointmentId = appointmentId
		}
	}

	static func == (lhs: BookableConflicts, rhs: BookableConflicts) -> Bool {
		return lhs.slotId == rhs.slotId
	}
}

extension BookableConflicts {
	static func sampleHardConflict() -> BookableConflicts {
		return BookableConflicts(
			slotId: "1",
			slotStatus: .hard,
			sailors: [ Sailor(reservationGuestId: "1", status: .hard, bookableType: .entertainment, appointmentId: nil) ]
		)
	}
}
