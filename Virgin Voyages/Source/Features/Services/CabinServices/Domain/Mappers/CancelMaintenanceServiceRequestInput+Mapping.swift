//
//  CancelMaintenanceServiceRequestInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/2/25.
//

import Foundation

extension CancelMaintenanceServiceRequestInput {
    
    func toNetworkDto() -> CancelMaintenanceServiceRequestBody {
        return .init(incidentId: self.incidentId,
                     incidentCategoryCode: self.incidentCategoryCode,
                     stateroom: self.stateroom,
                     reservationGuestId: self.reservationGuestId)
    }
}
