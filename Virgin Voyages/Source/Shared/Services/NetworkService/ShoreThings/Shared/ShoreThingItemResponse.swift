//
//  ShoreThingItemResponse.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.5.25.
//

struct ShoreThingItemResponse: Decodable {
	let id: String?
	let name: String?
	let imageUrl: String?
	let location: String?
	let price: Double?
	let priceFormatted: String?
	let energyLevel: String?
	let duration: String?
	let types: [String]?
	let introduction: String?
	let shortDescription: String?
	let longDescription: String?
	let needToKnows: [String]?
	let editorialBlocks: [String]?
	let highlightImageUrl: String?
	let highlights: [String]?
	let categoryCode: String?
	let currencyCode: String?
	let inventoryState: String?
	let bookingType: String?
	let isPreVoyageBookingStopped: Bool?
	let slots: [SlotResponse]?
	let portCode: String?
	let portStartDate: String?
	let portEndDate: String?
	let selectedSlot: SlotResponse?
	let appointments: AppointmentsResponse?
	let tourDifferentiators: [TourDifferentiator]?
	
	struct TourDifferentiator: Decodable {
		let name: String?
		let description: String?
		let imageURL: String?
	}
}

struct ShoreThingsListTypeResponse :Decodable {
	let code: String?
	let name: String?
}
