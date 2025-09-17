//
//  ShoreThingItem.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.5.25.
//

import Foundation

struct ShoreThingItem: Identifiable, Hashable {
	let id: String
	let name: String
	let imageUrl: String
	let location: String
	let price: Double
	let priceFormatted: String?
	let energyLevel: String
	let duration: String
	let types: [String]
	let introduction: String
	let shortDescription: String
	let longDescription: String
	let needToKnows: [String]
	let editorialBlocks: [String]
	let highlightImageUrl: String
	let highlights: [String]
	let categoryCode: String
	let currencyCode: String
	let inventoryState: InventoryState
	let bookingType: String
	let isPreVoyageBookingStopped: Bool
	let slots: [Slot]
	let portCode: String
	let portStartDate: String
	let portEndDate: String
	let selectedSlot: Slot?
	let appointments: Appointments?
	let tourDifferentiators: [TourDifferentiator]
	
	struct TourDifferentiator: Identifiable, Hashable {
		let id = UUID()
		let name: String
		let description: String
		let imageUrl: String
	}
}

struct ShoreThingsListType: Hashable {
	let code: String
	let name: String
}

extension ShoreThingItem {
    static func sample(
            id: String = "MIADEBARK",
            name: String = "Miami disembarkation group",
            imageUrl: String = "https://cert.gcpshore.virginvoyages.com/dam/jcr:e8d4e2c7-c384-4c52-a55b-82de0ee58eae/Embarkation%20Image_Hero_1200x800.png",
            location: String = "Miami",
            price: Double = 100,
            priceFormatted: String = "$100",
            energyLevel: String = "",
            duration: String = "15 Mins",
            types: [String] = [],
            introduction: String = "Helping you have the smoothest arrival experience at the end of your voyage.",
            shortDescription: String = "Book your arrival time at the end of your voyage",
            longDescription: String = "While we hate to say goodbye (we prefer, “sea you soon!”), we like to make sure that even the very end of your voyage is as breezy and enjoyable as the rest...",
            needToKnows: [String] = [
                "All Sailors are required to book a disembarkation time.",
                "Once you leave the ship, you will not be able to board again.",
                "To manage the number of Sailors in the terminal building, each group has limited availability.",
                "We cannot guarantee you can disembark the ship outside of your booked disembarkation group.",
                "All Sailors must leave the ship by 10:30am in order to comply with local immigration regulations."
            ],
            editorialBlocks: [String] = [],
            highlightImageUrl: String = "https://cert.gcpshore.virginvoyages.com/dam/jcr:bf2b8dc0-bf54-46fe-83d1-0b6207eef725/Embarkation%20Image%20-%20Mobile%20Highlight%20-%20750x1000.png",
            highlights: [String] = [
                "Cruise along the Bimini blues on a pontoon boat — built to bring the chill, Bahamian beach vibes out to sea",
                "Surround yourself in electric shades of turquoise water while cruising around Bimini's spellbinding coast",
                "Groove to the music while enjoying a selection of local beer, cocktails, sodas, and chips"
            ],
            categoryCode: String = "PA",
            currencyCode: String = "USD",
            inventoryState: InventoryState = .paidInventoried,
            bookingType: String = "Sample Booking",
            isPreVoyageBookingStopped: Bool = false,
            slots: [Slot] = [.sample()],
            portCode: String = "MIA",
            date: Date = Date(),
            selectedSlot: Slot? = .sample(),
            appointments: Appointments? = nil,
            tourDifferentiators: [TourDifferentiator] = [
                .init(name: "Top Rated",
                      description: "This Shore Thing is among the most popular with Sailors who have visited this port. Book before it is sold out!",
                      imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:c0b2c1dd-5b5d-4a6c-bede-62f1ed1c258d/VV623_TopRated_Icon_Final_White.png"),
                .init(name: "Sustainable Tour",
                      description: "This tour operator has received third-party certification based on the Global Sustainable Tourism Council criteria.",
                      imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:072e661e-3f60-44f3-a9a0-316cfab3a9ae/sustainable.png")
            ]
        ) -> ShoreThingItem {
            return ShoreThingItem(
                id: id,
                name: name,
                imageUrl: imageUrl,
                location: location,
                price: price,
                priceFormatted: priceFormatted,
                energyLevel: energyLevel,
                duration: duration,
                types: types,
                introduction: introduction,
                shortDescription: shortDescription,
                longDescription: longDescription,
                needToKnows: needToKnows,
                editorialBlocks: editorialBlocks,
                highlightImageUrl: highlightImageUrl,
                highlights: highlights,
                categoryCode: categoryCode,
                currencyCode: currencyCode,
                inventoryState: inventoryState,
                bookingType: bookingType,
                isPreVoyageBookingStopped: isPreVoyageBookingStopped,
                slots: slots,
                portCode: portCode,
                portStartDate: "",
				portEndDate: "",
                selectedSlot: selectedSlot,
                appointments: appointments,
                tourDifferentiators: tourDifferentiators
            )
        }

	func copy(
		id: String? = nil,
		name: String? = nil,
		imageUrl: String? = nil,
		location: String? = nil,
		price: Double? = nil,
		priceFormatted: String? = nil,
		energyLevel: String? = nil,
		duration: String? = nil,
		types: [String]? = nil,
		introduction: String? = nil,
		shortDescription: String? = nil,
		longDescription: String? = nil,
		needToKnows: [String]? = nil,
		editorialBlocks: [String]? = nil,
		highlightImageUrl: String? = nil,
		highlights: [String]? = nil,
		categoryCode: String? = nil,
		currencyCode: String? = nil,
		inventoryState: InventoryState? = nil,
		bookingType: String? = nil,
		isPreVoyageBookingStopped: Bool? = nil,
		slots: [Slot]? = nil,
		portCode: String? = nil,
		portStartDate: String? = nil,
		portEndDate: String? = nil,
		selectedSlot: Slot? = nil,
		appointments: Appointments? = nil,
		tourDifferentiators: [TourDifferentiator]? = nil
	) -> ShoreThingItem {
		return ShoreThingItem(
			id: id ?? self.id,
			name: name ?? self.name,
			imageUrl: imageUrl ?? self.imageUrl,
			location: location ?? self.location,
			price: price ?? self.price,
			priceFormatted: priceFormatted ?? self.priceFormatted,
			energyLevel: energyLevel ?? self.energyLevel,
			duration: duration ?? self.duration,
			types: types ?? self.types,
			introduction: introduction ?? self.introduction,
			shortDescription: shortDescription ?? self.shortDescription,
			longDescription: longDescription ?? self.longDescription,
			needToKnows: needToKnows ?? self.needToKnows,
			editorialBlocks: editorialBlocks ?? self.editorialBlocks,
			highlightImageUrl: highlightImageUrl ?? self.highlightImageUrl,
			highlights: highlights ?? self.highlights,
			categoryCode: categoryCode ?? self.categoryCode,
			currencyCode: currencyCode ?? self.currencyCode,
			inventoryState: inventoryState ?? self.inventoryState,
			bookingType: bookingType ?? self.bookingType,
			isPreVoyageBookingStopped: isPreVoyageBookingStopped ?? self.isPreVoyageBookingStopped,
			slots: slots ?? self.slots,
			portCode: portCode ?? self.portCode,
			portStartDate: portStartDate ?? self.portStartDate,
			portEndDate: portEndDate ?? self.portEndDate,
			selectedSlot: selectedSlot ?? self.selectedSlot,
			appointments: appointments ?? self.appointments,
			tourDifferentiators: tourDifferentiators ?? self.tourDifferentiators
		)
	}
}
