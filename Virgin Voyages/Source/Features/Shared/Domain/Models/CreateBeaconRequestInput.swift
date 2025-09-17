//
//  CreateBeaconRequestInput.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/8/25.
//

import Foundation

struct CreateBeaconRequestInput: Equatable {
    let reservationGuestId: String
    let beaconId: String?
}
