//
//  GetMySailorsRequestResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 19.2.25.
//

extension GetMySailorsRequestResponse {
	func toDomain(reservationGuestId: String) -> SailorModel {
		return SailorModel(
			id: self.guestId.value,
			guestId: self.guestId.value,
			reservationGuestId: self.reservationGuestId.value,
			reservationNumber: self.reservationNumber.value,
			name: self.name.value,
			profileImageUrl: self.profileImageUrl,
			isCabinMate: self.isCabinMate.value,
			isLoggedInSailor: self.reservationGuestId == reservationGuestId
		)
	}
}
