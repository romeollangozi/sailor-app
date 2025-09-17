//
//  SailorResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

import Foundation

extension SailorResponse {
	func toDomain(reservationGuestId: String) -> SailorModel {
		return .init(id: self.id.value,
					 guestId: self.guestId.value,
					 reservationGuestId: self.reservationGuestId.value,
					 reservationNumber: self.reservationNumber.value,
					 name: self.name.value,
					 profileImageUrl: self.profileImageUrl,
					 isCabinMate: self.isCabinMate.value,
					 isLoggedInSailor: self.reservationGuestId.value == reservationGuestId)
	}
}
