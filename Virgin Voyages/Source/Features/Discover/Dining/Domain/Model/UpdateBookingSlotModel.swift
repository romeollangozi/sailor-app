//
//  UpdateBookingSlotModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 5.12.24.
//

import Foundation

struct UpdateBookingSlotModel {
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

extension UpdateBookingSlotModel {
    static func map(from updateBookingSlot: UpdateBookingSlot) -> UpdateBookingSlotModel {
        return UpdateBookingSlotModel(
            appointment: updateBookingSlot.appointment.map { appointment in
                Appointment(
                    appointmentId: appointment.appointmentId,
                    appointmentLinkId: appointment.appointmentLinkId
                )
            },
            error: updateBookingSlot.error.map { error in
                Error(
                    status: error.status,
                    title: error.title
                )
            }
        )
    }
}

extension UpdateBookingSlotModel {
	static func successSample(appointmentId: String = UUID().uuidString, appointmentLinkId: String = UUID().uuidString) -> UpdateBookingSlotModel {
		return UpdateBookingSlotModel(appointment: Appointment(appointmentId: appointmentId, appointmentLinkId: appointmentLinkId), error: nil)
	}
	
	static func failedSample(title: String = "An error", status: Int = 400) -> UpdateBookingSlotModel {
		return UpdateBookingSlotModel(appointment: nil, error: Error(status: status, title: title))
	}
}
