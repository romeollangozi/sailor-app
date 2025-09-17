//
//  EventItemResponse.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 8.5.25.
//

struct EventItemResponse: Decodable {
	let id: String?
	let categoryCode: String?
	let name: String?
	let imageUrl: String?
	let location: String?
	let timePeriod: String?
	let date: String?
	let type: String?
	let introduction: String?
	let price: Double?
	let priceFormatted: String?
	let needToKnows: [String]?
	let editorialBlocks: [String]?
	let isBooked: Bool?
	let bookedText: String?
	let isBookingEnabled: Bool?
	let bookButtonText: String?
	let selectedSlot: SlotResponse?
	let appointments: AppointmentsResponse?
	let inventoryState: String?
	let slots: [SlotResponse]?
	
	// Additional properties from JSON
	let shortDescription: String?
	let longDescription: String?
	let currencyCode: String?
	let isPreVoyageBookingStopped: Bool?
	let bookingType: String?
}
