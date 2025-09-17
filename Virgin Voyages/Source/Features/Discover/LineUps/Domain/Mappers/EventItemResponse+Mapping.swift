//
//  EventItemResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 8.5.25.
//

extension EventItemResponse {
	func toDomain() -> LineUpEvents.EventItem {
		LineUpEvents.EventItem(
            eventID: self.id.value,
			categoryCode: self.categoryCode.value,
			name: self.name.value,
			imageUrl: self.imageUrl,
			location: self.location.value,
			timePeriod: self.timePeriod.value,
			type: self.type != nil ? .init(rawValue: self.type!)! : .bookable,
			bookingType: BookingType(rawValue: self.bookingType.value) ?? .other,
			introduction: self.introduction,
			longDescription: self.longDescription,
			price: self.price.value,
			priceFormatted: self.priceFormatted.value,
			currencyCode: self.currencyCode.value,
			needToKnows: self.needToKnows ?? [],
			editorialBlocks: self.editorialBlocks ?? [],
			isBooked: self.isBooked.value,
			bookedText: self.bookedText.value,
			isPreVoyageBookingStopped: self.isPreVoyageBookingStopped.value,
			isBookingEnabled: self.isBookingEnabled.value,
			bookButtonText: self.bookButtonText.value,
			selectedSlot: self.selectedSlot != nil ? self.selectedSlot!.toDomain() : nil,
			appointments: self.appointments.flatMap { appointments in appointments.toDomain() },
			inventoryState: self.inventoryState != nil ? .init(rawValue: self.inventoryState!)! : .nonInventoried,
			slots: self.slots?.compactMap { slot in slot.toDomain() } ?? []
		)
	}
}
