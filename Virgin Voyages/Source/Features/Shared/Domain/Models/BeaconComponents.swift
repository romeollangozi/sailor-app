//
//  BeaconComponents.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/10/25.
//

import Foundation
import CoreLocation

// MARK: - BeaconComponents
struct BeaconComponents {
    let uuid: String
    let major: CLBeaconMajorValue
    let minor: CLBeaconMinorValue
}
