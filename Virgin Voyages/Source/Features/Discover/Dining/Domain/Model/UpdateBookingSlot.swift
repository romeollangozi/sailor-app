//
//  UpdateBookingSlot.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

struct UpdateBookingSlot {
    let appointment: Appointment?
    let error: Error?
        
    struct Appointment {
        let appointmentId: String
        let appointmentLinkId: String
    }
    
    struct Error {
        let status: Int
        let title: String
    }
}
