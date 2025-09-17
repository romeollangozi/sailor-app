//
//  GetEateryAppointmentDetailsRequest+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

import Foundation

extension GetEateryAppointmentDetailsResponse {
	func toDomain(reservationGuestId: String) -> EateryAppointmentDetails {
		return EateryAppointmentDetails(
			id: self.id.value,
			linkId: self.linkId.value,
			imageUrl: self.imageUrl.value,
			category: self.category.value,
			pictogramUrl: self.pictogramUrl.value,
			name: self.name.value,
			startDateTime: Date.fromISOString(string: self.startDateTime),
			location: self.location.value,
			needToKnows: self.needToKnows ?? [],
			categoryCode: self.categoryCode.value,
			inventoryState: .nonInventoried,
			bookingType: self.bookingType.value,
			isPreVoyageBookingStopped: self.isPreVoyageBookingStopped.value,
			isWithinCancellationWindow: self.isWithinCancellationWindow.value,
			slotId: self.slotId.value,
			sailors: self.sailors?.map { $0.toDomain()} ?? [],
			mealPeriod: MealPeriod(rawValue: self.mealPeriod.value) ?? .dinner,
			externalId: self.externalId.value,
			venueId: self.venueId.value,
			isEditable: self.isEditable.value
		)
	}
}
