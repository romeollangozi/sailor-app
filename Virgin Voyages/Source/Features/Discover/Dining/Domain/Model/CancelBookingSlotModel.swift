//
//  CancelBookingSlotModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 11.12.24.
//

import Foundation

struct CancelBookingSlotModel {
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

extension CancelBookingSlotModel {
    static func map(from updateBookingSlot: UpdateBookingSlot) -> CancelBookingSlotModel {
        return CancelBookingSlotModel(
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

extension CancelBookingSlotModel {
	static func successSample(appointmentId: String = UUID().uuidString, appointmentLinkId: String = UUID().uuidString) -> CancelBookingSlotModel {
		return CancelBookingSlotModel(appointment: Appointment(appointmentId: appointmentId, appointmentLinkId: appointmentLinkId), error: nil)
	}
	
	static func failedSample(title: String = "An error", status: Int = 400) -> CancelBookingSlotModel {
		return CancelBookingSlotModel(appointment: nil, error: Error(status: status, title: title))
	}
}
