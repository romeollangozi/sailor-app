//
//  CancelAppointmentInput.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 4.2.25.
//

import Foundation

struct CancelAppointmentInput {
    let appointmentLinkId: String
    let isRefund: Bool
    let operationType: String = "CANCEL"
    let loggedInReservationGuestId: String
    let reservationNumber: String
    let categoryCode: String
    let personDetails: [PersonDetail]
    
    struct PersonDetail {
        let personId: String
        let guestId: String
        let reservationNumber: String
        let status: String
        
        init(personId: String, guestId: String, reservationNumber: String, status: String = "CANCELLED") {
            self.personId = personId
            self.guestId = guestId
            self.reservationNumber = reservationNumber
            self.status = status
        }
    }
}
