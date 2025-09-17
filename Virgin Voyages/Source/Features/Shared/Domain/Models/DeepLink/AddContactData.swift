//
//  AddContactData.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 1.9.25.
//

import Foundation

struct AddContactData: Codable, Hashable, Identifiable {
	let id: UUID = UUID()
	let reservationGuestId: String
	let reservationId: String
	let voyageNumber: String
	let name: String
}
