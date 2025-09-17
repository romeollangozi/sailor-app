//
//  SwapBookingSlotModel.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

import Foundation

struct SwapBookingSlotModel {
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

extension SwapBookingSlotModel {
    static func map(from updateBookingSlot: UpdateBookingSlot) -> SwapBookingSlotModel {
        return SwapBookingSlotModel(
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

extension SwapBookingSlotModel {
	static func successSample(appointmentId: String = UUID().uuidString, appointmentLinkId: String = UUID().uuidString) -> SwapBookingSlotModel {
		return SwapBookingSlotModel(appointment: Appointment(appointmentId: appointmentId, appointmentLinkId: appointmentLinkId), error: nil)
	}
	
	static func failedSample(title: String = "An error", status: Int = 400) -> SwapBookingSlotModel {
		return SwapBookingSlotModel(appointment: nil, error: Error(status: status, title: title))
	}
}
