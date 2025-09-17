//
//  UpdateBookingSlotModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 5.12.24.
//

import Foundation

struct UpdateBookingSlotInputModel {
	let sailors: [SailorModel]
    let activityCode: String
    let activitySlotCode: String
    let startDate: Date
    let appointmentLinkId: String
	let previousBookedSailors: [SailorModel]
}


