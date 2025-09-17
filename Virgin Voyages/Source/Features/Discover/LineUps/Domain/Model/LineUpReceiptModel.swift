//
//  LineUpReceiptModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.1.25.
//

import Foundation

struct LineUpReceiptModel: CancelBookableActivity {
    let id: String
    let imageUrl: String
    let category: String
    let pictogramUrl: String
    let name: String
    let startDateTime: Date
    let location: String
    let inventoryState: InventoryState
    let sailors: [SailorModel]
    let needToKnowTitle: String
    let needToKnow: [String]
	let editorialBlocks: [String]
    var editorialBlocksWithContent: [EditorialBlock]?
    let editText: String
    let viewAllText: String
    let shortDescription: String
    let longDescription: String
    let appointmentLinkId: String
    let isWithinCancellationWindow: Bool
	let price: Double
	let selectedSlot: Slot
	
	var refundTextForIndividual: String
	var refundTextForGroup: String?
	var currencyCode: String
	var refundConfirmationMessage: String
    let isPreVoyageBookingStopped: Bool
	let eventId: String
	let categoryCode: String
	let slots: [Slot]
    let isEditable: Bool
}

extension LineUpReceiptModel: Hashable, Equatable, Identifiable {
    static func == (lhs: LineUpReceiptModel, rhs: LineUpReceiptModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension LineUpReceiptModel {
    var cancelationCompletedText: String {
        return name
    }
}

extension LineUpReceiptModel {
    static func sample() -> LineUpReceiptModel {
        return LineUpReceiptModel(
            id: "12345",
            imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:54d66526-e3b5-4adb-bf6f-271178c541c9/IMG-ENT-The-Charmers-Lounge-1200x800.jpg",
            category: "EVENT",
            pictogramUrl: "https://example.com/pictogram.jpg",
            name: "Appointment Name",
            startDateTime: Date(),
            location: "B-Complex Balance, Deck 15",
			inventoryState: .nonInventoried,
            sailors: [
                SailorModel(
                    id: "1",
                    guestId: "8d062648-7996-4f90-911c-43e3a5249f63",
                    reservationGuestId: "659e9fb8-e897-4f59-aa08-99d8913a3b75",
                    reservationNumber: "123456",
                    name: "You",
                    profileImageUrl: "https://cert.gcpshore.virginvoyages.com/dxpcore/mediaitems/bbe9a663-587b-49a4-bf25-3a196ad63ff1",
                    isCabinMate: true,
					isLoggedInSailor: false
                ),
                SailorModel(
                    id: "2",
                    guestId: "2a07b023-4ed1-462e-bbcd-794fc57c361a",
                    reservationGuestId: "179d3cd1-4fd6-4fe8-9946-caf9de5bb698",
                    reservationNumber: "123457",
                    name: "Preferred Name",
                    profileImageUrl: nil,
					isCabinMate: true,
					isLoggedInSailor: false
                )
            ],
            needToKnowTitle: "NEED TO KNOW",
            needToKnow: ["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "],
			editorialBlocks: ["https://cert.gcpshore.virginvoyages.com/Sailor-App/Guides/Editorial-Blocks/events-alcohol-disclaimer/content/0.html"],
            editText: "Edit/Cancel",
            viewAllText: "View all Events",
            shortDescription: "TITLE",
            longDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
			appointmentLinkId: "dasdasdas-3424234",
			isWithinCancellationWindow: false,
			price: 10.0,
			selectedSlot: Slot.sample(),
			refundTextForIndividual: "",
			refundTextForGroup: "",
			currencyCode:"USD",
			refundConfirmationMessage: "",
            isPreVoyageBookingStopped: false,
			eventId: "61ab98e3248e3706b1c8673e",
			categoryCode: "NET",
			slots: [Slot.sample()],
            isEditable: false
        )
    }
}


extension LineUpReceiptModel {
    static func map(from appointment: LineUpAppointment) -> LineUpReceiptModel {
        return LineUpReceiptModel(
            id: appointment.id,
            imageUrl: appointment.imageUrl,
            category: appointment.category,
            pictogramUrl: appointment.pictogramUrl,
            name: appointment.name,
            startDateTime: appointment.startDateTime,
            location: appointment.location,
            inventoryState: appointment.inventoryState,
            sailors: appointment.sailors,
            needToKnowTitle: "NEED TO KNOW",
			needToKnow: appointment.needToKnows,
			editorialBlocks: appointment.editorialBlocks,
            editText: "Edit/Cancel",
            viewAllText: "View all Events",
            shortDescription: appointment.shortDescription,
            longDescription: appointment.longDescription,
			appointmentLinkId: appointment.linkId,
			isWithinCancellationWindow: appointment.isWithinCancellationWindow,
			price: appointment.price,
			selectedSlot: appointment.selectedSlot,
			refundTextForIndividual: "",
			refundTextForGroup: "",
			currencyCode: appointment.currencyCode,
			refundConfirmationMessage: "",
            isPreVoyageBookingStopped: appointment.isPreVoyageBookingStopped,
			eventId: appointment.eventId,
			categoryCode: appointment.categoryCode,
			slots: appointment.slots,
            isEditable: appointment.isEditable
        )
    }
}

extension LineUpReceiptModel {
    static func empty() -> LineUpReceiptModel {
        return LineUpReceiptModel(
            id: "",
            imageUrl: "",
            category: "",
            pictogramUrl: "",
            name: "",
            startDateTime: Date(),
            location: "",
			inventoryState: InventoryState.nonInventoried,
            sailors: [],
            needToKnowTitle: "",
            needToKnow: [],
			editorialBlocks: [],
            editText: "",
            viewAllText: "",
            shortDescription: "",
            longDescription: "",
			appointmentLinkId: "dasdasdas-3424234",
			isWithinCancellationWindow: false,
			price: 0.0,
			selectedSlot: Slot.sample(),
			refundTextForIndividual: "",
			refundTextForGroup: "",
			currencyCode: "",
			refundConfirmationMessage: "",
            isPreVoyageBookingStopped: false,
			eventId: "",
			categoryCode: "",
			slots: [],
            isEditable: false
        )
    }
}

extension InventoryState {
    func getInventoryStateTitleForLineUpReceipt() -> String {
        if self == .nonInventoried {
            return "PLANNED FOR"
        }
        return "BOOKED FOR"
    }
}
