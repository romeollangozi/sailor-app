//
//  CreateMaintenanceServiceResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/1/25.
//

import Foundation

extension CreateMaintenanceServiceResponse {
    
    func toDomain() -> CreateCabinServiceRequestResult {
        return .init(requestId: self.incidentId.value)
    }
    
}
