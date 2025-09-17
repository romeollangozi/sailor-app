//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

import Foundation

extension GetShoreThingReceiptResponse {
	func toDomain(reservationGuestId: String) -> ShoreThingReceiptDetails {
		.init(id: self.id.value,
              externalId: self.externalId.value,
			  linkId: self.linkId.value,
			  imageUrl: self.imageUrl.value,
			  category: self.category.value,
			  pictogramUrl: self.pictogramUrl.value,
			  name: self.name.value,
			  startDateTime: Date.fromISOString(string: self.startDateTime),
			  location: self.location.value,
			  meetingPlace: self.meetingPlace.value,
			  duration: self.duration.value,
			  energyLevel: self.energyLevel,
			  types: self.types ?? [],
			  reminders: self.reminders ?? [],
			  portCode: self.portCode.value,
			  categoryCode: self.categoryCode.value,
			  currencyCode: self.currencyCode.value,
			  price: self.price.value,
			  inventoryState: self.inventoryState != nil ? .init(rawValue: self.inventoryState!)! : .nonInventoried,
			  isPreVoyageBookingStopped: self.isPreVoyageBookingStopped.value,
			  isWithinCancellationWindow: self.isWithinCancellationWindow.value,
			  slots: self.slots?.map({$0.toDomain() }) ?? [],
			  selectedSlot: self.selectedSlot?.toDomain() ?? .empty(),
			  sailors: self.sailors?.map({$0.toDomain() }) ?? [],
			  isEditable: self.isEditable.value,
			  waiver: self.waiver != nil
			  ? ShoreThingReceiptDetails.Waiver(status: self.waiver!.status.value,
												code: self.waiver!.code.value,
												version: self.waiver!.version.value)
			  : nil)
	}
}
