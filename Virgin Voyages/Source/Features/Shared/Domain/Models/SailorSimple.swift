//
//  SailorSimple.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

import Foundation

struct SailorSimple: Identifiable, Hashable, Equatable {
	var id : String {
		return reservationGuestId
	}
	let guestId: String
	let reservationGuestId: String
	let reservationNumber: String
	let name: String
	let profileImageUrl: String?
	
	init(guestId: String,
		 reservationGuestId: String,
		 reservationNumber: String,
		 name: String,
		 profileImageUrl: String? = nil) {
		self.guestId = guestId
		self.reservationGuestId = reservationGuestId
		self.reservationNumber = reservationNumber
		self.name = name
		self.profileImageUrl = profileImageUrl
	}
	
	static func == (lhs: SailorSimple, rhs: SailorSimple) -> Bool {
		return lhs.reservationGuestId == rhs.reservationGuestId
	}
}

extension SailorSimple {
	static func empty() -> SailorSimple {
		return SailorSimple(
						   guestId: "",
						   reservationGuestId: "",
						   reservationNumber: "",
						   name: "",
						   profileImageUrl: nil
		)
	}
	
	static func sample() -> SailorSimple  {
		return SailorSimple(guestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
						   reservationGuestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
						   reservationNumber: "11111",
						   name: "John",
						   profileImageUrl: nil
		)
	}
}

extension Array where Element == SailorSimple {
	func getOnlyReservationGuestIds() -> [String] {
		return self.map({x in x.reservationGuestId})
	}
}
