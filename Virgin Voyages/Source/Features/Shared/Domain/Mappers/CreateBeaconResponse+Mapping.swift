//
//  CreateBeaconResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/8/25.
//

import Foundation

extension CreateBeaconResponse {
    
    func toDomain() -> CreateBeaconRequestResult {
        .init(beaconId: self.beaconId.value)
    }
}
