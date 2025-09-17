//
//  SlotResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 8.5.25.
//

import Foundation

extension SlotResponse {
	func toDomain() -> Slot {
		return Slot(id: self.id.value,
					startDateTime: Date.fromISOString(string: self.startDateTime),
					endDateTime: Date.fromISOString(string: self.endDateTime),
					status: SlotStatus(rawValue: self.status ?? "") ?? .available,
					isBooked: self.isBooked.value,
					inventoryCount: self.inventoryCount.value)
	}
}
	
