//
//  BookSlot.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

import Foundation

struct BookSlot {
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

extension BookSlot {
	static func successSample(appointmentId: String = UUID().uuidString, appointmentLinkId: String = UUID().uuidString) -> BookSlot {
		return BookSlot(appointment: Appointment(appointmentId: appointmentId, appointmentLinkId: appointmentLinkId), error: nil)
	}
	
	static func failedSample(title: String = "An error", status: Int = 400) -> BookSlot {
		return BookSlot(appointment: nil, error: Error(status: status, title: title))
	}
}
		
