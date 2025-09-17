//
//  AddContactNotificationData.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 1.9.25.
//

struct AddContactNotificationData: Codable {
	let reservationGuestId: String?
	let reservationId: String?
	let voyageNumber: String?
	let name: String?
}
