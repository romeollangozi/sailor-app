//
//  CreateBeaconRequestResult.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/8/25.
//

import Foundation

struct CreateBeaconRequestResult: Equatable {
    let beaconId: String
}

extension CreateBeaconRequestResult {
    
    static func sample() -> CreateBeaconRequestResult {
        
        CreateBeaconRequestResult(beaconId: "c55b7f82-3d35-11eb-6439-2242cc110001:31933:25650")
    }
}
