//
//  CancelBookingSlotInputModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 11.12.24.
//

import Foundation

struct CancelBookingSlotInputModel {
    let personDetails: [PersonDetail]
    let activityCode: String
    let activitySlotCode: String
    let startDate: Date
    let appointmentLinkId: String
	let guests: Int
	
    struct PersonDetail {
        let personId: String
        let reservationNumber: String
        let guestId: String
    }
}
