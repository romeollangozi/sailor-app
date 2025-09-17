//
//  ShoreThingReceiptDetails.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

import Foundation

struct ShoreThingReceiptDetails {
	let id: String
	let externalId: String
	let linkId: String
	let imageUrl: String
	let category: String
	let pictogramUrl: String
	let name: String
	let startDateTime: Date
	let location: String
	let meetingPlace: String
	let duration: String
	let energyLevel: String?
	let types: [String]
	let reminders: [String]
	let portCode: String
	let categoryCode: String
	let currencyCode: String
	let price: Double
	let inventoryState: InventoryState
	let isPreVoyageBookingStopped: Bool
	let isWithinCancellationWindow: Bool
	let slots: [Slot]
	let selectedSlot: Slot
	let sailors: [SailorSimple]
	let isEditable: Bool
	let waiver: Waiver?
	
	struct Waiver {
		let status: String
		let code: String
		let version: String
	}
}

extension ShoreThingReceiptDetails {
	static func empty() -> ShoreThingReceiptDetails {
		return ShoreThingReceiptDetails(
			id: "",
            externalId: "",
			linkId: "",
			imageUrl: "",
			category: "",
			pictogramUrl: "",
			name: "",
			startDateTime: Date(),
			location: "",
			meetingPlace: "",
			duration: "",
			energyLevel: nil,
			types: [],
			reminders: [],
			portCode: "",
			categoryCode: "",
			currencyCode: "",
			price: 0.0,
			inventoryState: .nonInventoried,
			isPreVoyageBookingStopped: false,
			isWithinCancellationWindow: false,
			slots: [],
			selectedSlot: Slot.empty(),
			sailors: [],
			isEditable: false,
			waiver: nil
		)
	}
}

extension ShoreThingReceiptDetails {
	static func sample() -> ShoreThingReceiptDetails {
		return ShoreThingReceiptDetails(
			id: "a9d659d1-e8d4-46fb-93f1-1e41a29ddfa8",
            externalId: "a9d659d1-e8d4-46fb-93f1-1e41a29ddfa8",
			linkId: "5a9aff43-94cc-49f7-8c0c-495f53653424",
			imageUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:2ada56b1-5696-4b7f-9205-1c64c14e0f62/IMG-DEST-COZUMEL-MEXICO-Atlantis-Submarine-Expedition-VENDOR-1200x800.jpg",
			category: "SHORE EXCURSION",
			pictogramUrl: "https://cms-cert.ship.virginvoyages.com/dam/jcr:2c9fa664-19a9-49ef-b5b5-da0f6658697e/PTG-SHORETHINGS-booking-type-shorethings-80x80.svg",
			name: "Atlantis Submarine Expedition",
			startDateTime: Date(),
			location: "ActivityShoreSide - Blue lagoon",
			meetingPlace: "",
			duration: "150 Mins",
			energyLevel: nil,
			types: ["Cultured", "Adventurous"],
			reminders: ["Backpack/bag for personal items",
						"Camera", "Cash and/or credit card",
						"Comfortable walking shoes",
						"Refillable water bottle",
						"Valid government-issued ID"],
			portCode: "CZM",
			categoryCode: "PA",
			currencyCode: "USD",
			price: 90,
			inventoryState: .paidInventoried,
			isPreVoyageBookingStopped: false,
			isWithinCancellationWindow: false,
			slots: [Slot.sample()],
			selectedSlot: Slot.sample(),
			sailors: [
                SailorSimple(
                    guestId: "8d062648-7996-4f90-911c-43e3a5249f63",
                    reservationGuestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
                    reservationNumber: "123456",
                    name: "You",
                    profileImageUrl: "https://cert.gcpshore.virginvoyages.com/dxpcore/mediaitems/bbe9a663-587b-49a4-bf25-3a196ad63ff1"
                ),
                SailorSimple(
                    guestId: "2a07b023-4ed1-462e-bbcd-794fc57c361a",
                    reservationGuestId: "179d3cd1-4fd6-4fe8-9946-caf9de5bb698",
                    reservationNumber: "123457",
                    name: "Preferred Name",
                    profileImageUrl: nil
                )
            ],
			isEditable: false,
			waiver: nil
		)
	}
}


extension ShoreThingReceiptDetails {
	func copy(
		id: String? = nil,
        externalId: String? = nil,
		linkId: String? = nil,
		imageUrl: String? = nil,
		category: String? = nil,
		pictogramUrl: String? = nil,
		name: String? = nil,
		startDateTime: Date? = nil,
		location: String? = nil,
		meetingPlace: String? = nil,
		duration: String? = nil,
		energyLevel: String? = nil,
		types: [String]? = nil,
		reminders: [String]? = nil,
		portCode: String? = nil,
		categoryCode: String? = nil,
		currencyCode: String? = nil,
		price: Double? = nil,
		inventoryState: InventoryState? = nil,
		isPreVoyageBookingStopped: Bool? = nil,
		isWithinCancellationWindow: Bool? = nil,
		slots: [Slot]? = nil,
		selectedSlot: Slot? = nil,
		sailors: [SailorSimple]? = nil,
		isEditable: Bool? = nil,
		waiver: Waiver? = nil
	) -> ShoreThingReceiptDetails {
		return ShoreThingReceiptDetails(
			id: id ?? self.id,
            externalId: externalId ?? self.externalId,
			linkId: linkId ?? self.linkId,
			imageUrl: imageUrl ?? self.imageUrl,
			category: category ?? self.category,
			pictogramUrl: pictogramUrl ?? self.pictogramUrl,
			name: name ?? self.name,
			startDateTime: startDateTime ?? self.startDateTime,
			location: location ?? self.location,
			meetingPlace: meetingPlace ?? self.meetingPlace,
			duration: duration ?? self.duration,
			energyLevel: energyLevel ?? self.energyLevel,
			types: types ?? self.types,
			reminders: reminders ?? self.reminders,
			portCode: portCode ?? self.portCode,
			categoryCode: categoryCode ?? self.categoryCode,
			currencyCode: currencyCode ?? self.currencyCode,
			price: price ?? self.price,
			inventoryState: inventoryState ?? self.inventoryState,
			isPreVoyageBookingStopped: isPreVoyageBookingStopped ?? self.isPreVoyageBookingStopped,
			isWithinCancellationWindow: isWithinCancellationWindow ?? self.isWithinCancellationWindow,
			slots: slots ?? self.slots,
			selectedSlot: selectedSlot ?? self.selectedSlot,
			sailors: sailors ?? self.sailors,
			isEditable: isEditable ?? self.isEditable,
			waiver: waiver ?? self.waiver
		)
	}
}
