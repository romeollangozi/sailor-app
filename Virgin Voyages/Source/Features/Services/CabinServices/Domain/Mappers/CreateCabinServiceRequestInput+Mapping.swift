//
//  CreateCabinServiceRequestInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//

import Foundation

extension CreateCabinServiceRequestInput {
	func toNetworkDto() -> CreateCabinServiceRequestBody {
		return .init(reservationId: self.reservationId,
					 reservationGuestId: self.reservationGuestId,
					 guestId: self.guestId,
					 cabinNumber: self.cabinNumber,
					 requestName: self.requestName)
		
	}
}
