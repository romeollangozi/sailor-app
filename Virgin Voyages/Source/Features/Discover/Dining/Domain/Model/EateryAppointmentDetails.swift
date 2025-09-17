//
//  EateryAppointmentDetails.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

import Foundation

struct EateryAppointmentDetails : Equatable {
	let id: String
	let linkId: String
	let imageUrl: String
	let category: String
	let pictogramUrl: String
	let name: String
	let startDateTime: Date
	let location: String
	let needToKnows: [String]
	let categoryCode: String
	let inventoryState: InventoryState
	let bookingType: String
	let isPreVoyageBookingStopped: Bool
	let isWithinCancellationWindow: Bool
	let slotId: String
	let sailors: [SailorSimple]
	let mealPeriod: MealPeriod
	let externalId: String
	let venueId: String
	let isEditable: Bool
}

extension EateryAppointmentDetails {
	static func sample() -> EateryAppointmentDetails {
		return EateryAppointmentDetails(
			id: "2b5b5710-1278-43a6-93ff-15a505cd8f6e",
			linkId: "4b819655-5252-42af-8983-e2753559f91f",
			imageUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:2d3ae14f-35f5-4121-9420-20c0a379c681/lucky-lotus-by-razzle-dazzle-signature-shot-1200x1440.jpg",
			category: "RESTAURANTS",
			pictogramUrl: "https://cert.gcpshore.virginvoyages.com/dam/jcr:4c3ef2aa-745e-45f8-872d-e05e24783309/PTG-SHORETHINGS-booking-type-dining-80x80.svg",
			name: "Razzle Dazzle Restaurant",
			startDateTime: Date(),
			location: "Razzle Dazzle Restaurant, Deck 5 Mid",
			needToKnows: ["Arrive 15 minutes early", "Dress code: Casual"],
			categoryCode: "RT",
			inventoryState: .nonInventoried,
			bookingType: "SDSI",
			isPreVoyageBookingStopped: false,
			isWithinCancellationWindow: false,
			slotId: "5a4bf485da0c112a66ed6217-1745006400000-1-2-SC",
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
			mealPeriod: .dinner,
			externalId: "2b5b5710-1278-43a6-93ff-15a505cd8f6e",
			venueId: "2b5b5710-1278-43a6-93ff-15a505cd8f6e",
			isEditable: false
		)
	}
}

extension EateryAppointmentDetails {
	static func empty() -> EateryAppointmentDetails {
		return EateryAppointmentDetails(
			id: "",
			linkId: "",
			imageUrl: "",
			category: "",
			pictogramUrl: "",
			name: "",
			startDateTime: Date(),
			location: "",
			needToKnows: [],
			categoryCode: "",
			inventoryState: .nonInventoried,
			bookingType: "",
			isPreVoyageBookingStopped: false,
			isWithinCancellationWindow: false,
			slotId: "",
			sailors: [],
			mealPeriod: .dinner,
			externalId: "",
			venueId: "",
			isEditable: false
		)
	}
}
