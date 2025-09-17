//
//  LoadTreatmentPurchaseSheetUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/17/25.
//

import Foundation

protocol LoadTreatmentPurchaseSheetUseCaseProtocol {
	func execute(
		treatmentDetails: TreatmentDetails,
		selectedOption: TreatmentOption,
		alreadyBookedSlot: Slot?
	) async throws -> TreatmentPurchaseSheetModel
}

extension LoadTreatmentPurchaseSheetUseCaseProtocol {
	func execute(
		treatmentDetails: TreatmentDetails,
		selectedOption: TreatmentOption
	) async throws -> TreatmentPurchaseSheetModel {
		return try await execute(
			treatmentDetails: treatmentDetails,
			selectedOption: selectedOption,
			alreadyBookedSlot: nil)
	}
}


@Observable class TreatmentPurchaseSheetModel {
	let treatmentDetails: TreatmentDetails
	let selectedOption: TreatmentOption
	let guests: [ActivitiesGuest]
	var selectedGuests: [ActivitiesGuest] = []
    let itineraryDates: [Date]
	let alreadyBookedSlot: Slot?

	init(
		treatmentDetails: TreatmentDetails,
		selectedOption: TreatmentOption,
		guests: [ActivitiesGuest],
		selectedGuests: [ActivitiesGuest],
        itineraryDates: [Date],
		alreadyBookedSlot: Slot? = nil
	) {
		self.treatmentDetails = treatmentDetails
		self.selectedOption = selectedOption
		self.guests = guests
		self.selectedGuests = selectedGuests
        self.itineraryDates = itineraryDates
		self.alreadyBookedSlot = alreadyBookedSlot
	}

	func toggleGuest(_ guest: ActivitiesGuest) {
		if let guest = guests.first(where: { $0.guestId == guest.id }) {
			selectedGuests.toggle(guest)
		}
	}
}
