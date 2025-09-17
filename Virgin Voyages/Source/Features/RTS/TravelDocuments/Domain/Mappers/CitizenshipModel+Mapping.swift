//
//  CitizenshipModel+Mapping.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 8.9.25.
//

import Foundation

extension CitizenshipModel {
    func toNetworkDTO() -> SaveCitizenshipBody {
        return SaveCitizenshipBody(
            citizenshipCountryCode: self.citizenshipCountryCode,
            reservationGuestId: self.reservationGuestId
        )
    }
}
