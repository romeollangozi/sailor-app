//
//  CancelAppointmentInput+Mapping.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/7/25.
//

import Foundation

extension CancelAppointmentInput {
	func toDTO() -> CancelAppointmentRequestBody {
		CancelAppointmentRequestBody(
			appointmentLinkId: appointmentLinkId,
			isRefund: isRefund,
			operationType: operationType,
			loggedInReservationGuestId: loggedInReservationGuestId,
			reservationNumber: reservationNumber,
			categoryCode: categoryCode,
			personDetails: personDetails.map { $0.toDTO() }
		)
	}
}

extension CancelAppointmentInput.PersonDetail {
	func toDTO() -> CancelAppointmentRequestBody.PersonDetail {
		return CancelAppointmentRequestBody.PersonDetail(
			personId: personId,
			guestId: guestId,
			reservationNumber: reservationNumber,
			status: status
		)
	}
}

extension Array where Element == CancelAppointmentInputModel.PersonDetail {
	func toDTO() -> [CancelAppointmentInput.PersonDetail] {
		return self.map { $0.toDTO() }
	}
}

extension CancelAppointmentInputModel.PersonDetail {
	func toDTO() -> CancelAppointmentInput.PersonDetail {
		return CancelAppointmentInput.PersonDetail(
			personId: self.personId,
			guestId: self.guestId,
			reservationNumber: self.reservationNumber,
			status: "CANCELLED"
		)
	}
}
