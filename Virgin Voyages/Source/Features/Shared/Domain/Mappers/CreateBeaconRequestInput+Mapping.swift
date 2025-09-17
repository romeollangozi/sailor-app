//
//  CreateBeaconRequestInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/8/25.
//

import Foundation

extension CreateBeaconRequestInput {
    
    func toNetworkDto() -> CreateBeaconRequestBody {
        .init(reservationGuestId: self.reservationGuestId,
              beaconId: self.beaconId)
    }
}
