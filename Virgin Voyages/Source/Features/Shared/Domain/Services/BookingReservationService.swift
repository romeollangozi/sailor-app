//
//  BookingReservationService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/5/25.
//

import Foundation

protocol BookingReservationServiceProtocol {
    func getCurrentReservationDetails() throws -> ReservationDetails
}

struct ReservationDetails {
    let reservationGuestId: String
    let reservationNumber: String
    let voyageNumber: String
    let shipCode: String
}

class BookingReservationService: BookingReservationServiceProtocol {
	func getCurrentReservationDetails() throws -> ReservationDetails {
		guard let currentSailor = try? AuthenticationService.shared.currentSailor() else {
			throw VVDomainError.genericError
		}

		let reservationGuestId = currentSailor.reservation.reservationGuestId
		let reservationNumber = currentSailor.reservation.reservationNumber
		let voyageNumber = currentSailor.reservation.voyageNumber
		let shipCode = currentSailor.reservation.shipCode.rawValue

		return ReservationDetails(
			reservationGuestId: reservationGuestId,
			reservationNumber: reservationNumber,
			voyageNumber: voyageNumber,
			shipCode: shipCode
		)
	}
}
