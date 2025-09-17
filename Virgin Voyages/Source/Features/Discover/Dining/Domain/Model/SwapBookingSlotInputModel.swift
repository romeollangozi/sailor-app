//
//  UpdateBookingSlotInputModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

import Foundation

struct SwapBookingSlotInputModel {
    let personDetails: [PersonDetail]
    let activityCode: String
    let activitySlotCode: String
    let startDate: Date
    let appointmentLinkId: String
    
    struct PersonDetail {
        let personId: String
        let reservationNumber: String
        let guestId: String
    }
}
