//
//  ShoreThingItemResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.5.25.
//

import Foundation

extension ShoreThingItemResponse {
	func toDomain() -> ShoreThingItem {
		.init(id: self.id.value,
			  name: self.name.value,
			  imageUrl: self.imageUrl.value,
			  location: self.location.value,
			  price: self.price.value,
			  priceFormatted: self.priceFormatted.value,
			  energyLevel: self.energyLevel.value,
			  duration: self.duration.value,
			  types: self.types ?? [],
			  introduction: self.introduction.value,
			  shortDescription: self.shortDescription.value,
			  longDescription: self.longDescription.value,
			  needToKnows: self.needToKnows ?? [],
			  editorialBlocks: self.editorialBlocks ?? [],
			  highlightImageUrl: self.highlightImageUrl.value,
			  highlights: self.highlights ?? [],
			  categoryCode: self.categoryCode.value,
			  currencyCode: self.currencyCode.value,
			  inventoryState: InventoryState.from(string: self.inventoryState),
			  bookingType: self.bookingType.value,
              isPreVoyageBookingStopped: self.isPreVoyageBookingStopped.value,
			  slots: self.slots?.map({$0.toDomain() }) ?? [],
			  portCode: self.portCode.value,
			  portStartDate: self.portStartDate ?? "",
			  portEndDate: self.portEndDate ?? "",
			  selectedSlot: self.selectedSlot?.toDomain(),
			  appointments: self.appointments?.toDomain(),
			  tourDifferentiators: self.tourDifferentiators?.map({$0.toDomain() }) ?? []
		)
	}
}

extension ShoreThingItemResponse.TourDifferentiator {
	func toDomain() -> ShoreThingItem.TourDifferentiator {
		.init(name: self.name.value,
			  description: self.description.value,
			  imageUrl: self.imageURL.value)
	}
}
