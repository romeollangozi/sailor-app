//
//  LineUpAppointment.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.1.25.
//

import Foundation

struct LineUpAppointment {
    let id: String
    let imageUrl: String
    let category: String
    let pictogramUrl: String
    let name: String
    let startDateTime: Date
    let location: String
    let needToKnows: [String]
	let editorialBlocks: [String]
    let shortDescription: String
    let longDescription: String
    let linkId: String
    let inventoryState: InventoryState
    let sailors: [SailorModel]
    let isWithinCancellationWindow: Bool
	let price: Double
	let currencyCode: String
    let isPreVoyageBookingStopped: Bool
	let selectedSlot: Slot
	let eventId: String
	let categoryCode: String
	let slots: [Slot]
    let isEditable: Bool
}

extension LineUpAppointment {
    static func map(from response: GetLineUpAppointmentResponse, reservationGuestId: String) -> LineUpAppointment {
        return LineUpAppointment(
            id: response.id.value,
            imageUrl: response.imageUrl.value,
            category: response.category.value,
            pictogramUrl: response.pictogramUrl.value,
            name: response.name.value,
			startDateTime: Date.fromISOString(string: response.startDateTime),
            location: response.location.value,
			needToKnows: response.needToKnows ?? [],
			editorialBlocks: response.editorialBlocks ?? [],
            shortDescription: response.shortDescription.value,
            longDescription: response.longDescription.value,
            linkId: response.linkId.value,
            inventoryState: InventoryState(rawValue: response.inventoryState.value) ?? .nonInventoried,
            sailors: response.sailors?.map { sailor in
                SailorModel(
                    id: sailor.reservationGuestId.value, guestId: sailor.guestId.value,
                    reservationGuestId: sailor.reservationGuestId.value,
                    reservationNumber: sailor.reservationNumber.value,
                    name: sailor.name.value,
                    profileImageUrl: sailor.profileImageUrl,
                    isCabinMate: sailor.isCabinMate ?? false,
					isLoggedInSailor: sailor.reservationGuestId.value == reservationGuestId
                )
            } ?? [],
			isWithinCancellationWindow: response.isWithinCancellationWindow.value,
			price: response.price.value,
			currencyCode: response.currencyCode.value,
            isPreVoyageBookingStopped: response.isPreVoyageBookingStopped.value,
			selectedSlot: response.selectedSlot?.toDomain() ?? Slot.empty(),
			eventId: response.externalId.value,
			categoryCode: response.categoryCode.value,
			slots: response.slots?.map({ $0.toDomain() }) ?? [],
            isEditable: response.isEditable.value
        )
    }
}

extension LineUpAppointment {
    static func sample() -> LineUpAppointment {
        return LineUpAppointment(
            id: "12345",
            imageUrl: "https://example.com/image.jpg",
            category: "Music",
            pictogramUrl: "https://example.com/pictogram.png",
            name: "Rock Concert",
            startDateTime: ISO8601DateFormatter().date(from: "2025-01-28T19:00:00Z") ?? Date(),
            location: "Concert Hall",
            needToKnows: ["Bring ID", "No re-entry allowed"],
			editorialBlocks: ["https://cert.gcpshore.virginvoyages.com/guest-bff/nsa/line-ups/appointments/d5853d04-6aba-4d35-b274-f4064289220f"],
            shortDescription: "An amazing rock concert.",
            longDescription: "Join us for an incredible night of live rock music featuring top bands.",
            linkId: "dsdsadsad-423423423",
            inventoryState: .nonInventoried,
            sailors: [
                SailorModel(
                    id: "1001",
                    guestId: "2001",
                    reservationGuestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
                    reservationNumber: "ABC123",
                    name: "John Doe",
                    profileImageUrl: "https://example.com/john.jpg",
                    isCabinMate: true,
					isLoggedInSailor: false
                ),
                SailorModel(
                    id: "1002",
                    guestId: "2002",
                    reservationGuestId: "179d3cd1-4fd6-4fe8-9946-caf9de5bb698",
                    reservationNumber: "DEF456",
                    name: "Jane Smith",
                    profileImageUrl: "https://example.com/jane.jpg",
                    isCabinMate: false,
					isLoggedInSailor: false
                )
			], isWithinCancellationWindow: false,
			price: 0.0,
            currencyCode: "USD",
            isPreVoyageBookingStopped: false,
			selectedSlot: Slot.sample(),
			eventId: "event12345",
			categoryCode: "NET",
			slots: [Slot.sample()],
            isEditable: false
        )
    }
}
