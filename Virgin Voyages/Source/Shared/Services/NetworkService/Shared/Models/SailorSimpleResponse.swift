//
//  SailorSimpleResponse.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

struct SailorSimpleResponse: Decodable {
	let guestId: String?
	let reservationGuestId: String?
	let reservationNumber: String?
	let name: String?
	let profileImageUrl: String?
}
