//
//  LineUpPurchaseSheetModel.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/7/25.
//

import Foundation

@Observable class LineUpPurchaseSheetModel {
	let event: LineUpEvents.EventItem
	var guests: [ActivitiesGuest]
	var selectedGuests: [ActivitiesGuest] = []
    let itineraryDates: [Date]

	init(event: LineUpEvents.EventItem, guests: [ActivitiesGuest], selectedGuests: [ActivitiesGuest], itineraryDates: [Date]) {
		self.event = event
		self.guests = guests
        self.selectedGuests = selectedGuests
        self.itineraryDates = itineraryDates
	}

	func toggleGuest(_ guest: ActivitiesGuest) {
		if let guest = guests.first(where: { $0.guestId == guest.id }) {
			selectedGuests.toggle(guest)
		}
	}
}
