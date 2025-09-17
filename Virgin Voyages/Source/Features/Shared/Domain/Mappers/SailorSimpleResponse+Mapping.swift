//
//  SailorSimpleResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

import Foundation

extension SailorSimpleResponse {
	func toDomain() -> SailorSimple {
		return .init(
			guestId: self.guestId.value,
			reservationGuestId: self.reservationGuestId.value,
			reservationNumber: self.reservationNumber.value,
			name: self.name.value,
			profileImageUrl: self.profileImageUrl)
	}
}
