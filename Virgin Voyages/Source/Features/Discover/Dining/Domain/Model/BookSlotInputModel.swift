//
//  BookSlotInput.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

import Foundation

struct BookSlotInputModel {
    let personDetails: [PersonDetail]
    let activityCode: String
    let activitySlotCode: String
    let startDate: Date
    
    struct PersonDetail {
        let personId: String
        let reservationNumber: String
        let guestId: String
    }
}
