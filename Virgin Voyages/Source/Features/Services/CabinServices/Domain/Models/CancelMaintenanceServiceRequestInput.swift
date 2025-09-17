//
//  CancelMaintenanceServiceRequestInput.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/2/25.
//

import Foundation

struct CancelMaintenanceServiceRequestInput: Equatable {
    let incidentId: String
    let incidentCategoryCode: String
    let stateroom: String
    let reservationGuestId: String
}
