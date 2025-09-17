//
//  SailorResponse.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

struct SailorResponse: Decodable {
	let id: String?
	let guestId: String?
	let reservationGuestId: String?
	let reservationNumber: String?
	let name: String?
	let profileImageUrl: String?
	let isCabinMate: Bool?
}
