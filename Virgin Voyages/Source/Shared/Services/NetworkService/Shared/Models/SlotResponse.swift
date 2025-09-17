//
//  SlotResponse.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 8.5.25.
//

struct SlotResponse: Decodable {
	let id: String?
	let startDateTime: String?
	let endDateTime: String?
	let status: String?
	let isBooked: Bool?
	let inventoryCount: Int?
}
