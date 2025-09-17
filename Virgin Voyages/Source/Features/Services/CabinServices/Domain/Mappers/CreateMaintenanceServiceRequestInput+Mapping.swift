//
//  CreateMaintenanceServiceRequestInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/1/25.
//

import Foundation

extension CreateMaintenanceServiceRequestInput {
    
    func toNetworkDto() -> CreateMaintenanceServiceRequestBody {
        return .init(reservationGuestId: self.reservationGuestId,
                     stateroom: self.stateroom,
                     incidentCategoryCode: self.incidentCategoryCode)
    }
}
