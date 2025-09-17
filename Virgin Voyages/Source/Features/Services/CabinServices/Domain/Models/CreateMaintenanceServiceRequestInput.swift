//
//  CreateMaintenanceServiceRequestInput.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/1/25.
//

import Foundation

struct CreateMaintenanceServiceRequestInput: Equatable {
    let reservationGuestId: String
    let stateroom: String
    let incidentCategoryCode: String
}
