//
//  AddContactNotificationData+Mapping.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 1.9.25.
//

import Foundation

extension AddContactNotificationData {

	func toDomain() -> AddContactData {
		.init(reservationGuestId: self.reservationGuestId.value,
			  reservationId: self.reservationId.value,
			  voyageNumber: self.voyageNumber.value,
			  name: self.name.value)
	}
}
