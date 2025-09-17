//
//  CancelAppointmentModel.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.2.25.
//

import Foundation

struct CancelAppointment {
    let appointmentLinkId: String
    let paymentStatus: String
    let message: Error?

    struct Error {
        let status: Int?
        let title: String?

		static func mapFromResponse(response: CancelAppointmentResponse.Error?) -> CancelAppointment.Error? {
			guard let response = response else { return nil }
			return .init(status: response.status.value, title: response.title.value)
		}
    }
}

extension CancelAppointment {
    static func map(from response: CancelAppointmentResponse) -> CancelAppointment {
        return .init(appointmentLinkId: response.appointmentLinkId.value,
					 paymentStatus: response.paymentStatus.value,
					 message: CancelAppointment.Error.mapFromResponse(response: response.message))
    }

    static func empty() -> CancelAppointment {
        return .init(appointmentLinkId: "", paymentStatus: "", message: nil)
    }

    static func sample() -> CancelAppointment {
        return .init(appointmentLinkId: "44444-55555-66aa66-7777", paymentStatus: "CANCELED", message: nil)
    }

}
