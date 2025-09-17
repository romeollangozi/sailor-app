//
//  ClaimBookingUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/11/24.
//

import Foundation

enum ClaimBookingUseCaseResult: Equatable {
	case success
	case successRequiresAuthentication
	case bookingNotFound
	case emailConflict(email: String, reservationNumber: String, reservationGuestID: String)
    case guestConflict(reservationNumber: String, guestDetails: [ClaimBookingGuestDetails])
}

class ClaimBookingUseCase {

	private let bookingService: BookingServiceProtocol

	init(bookingService: BookingServiceProtocol = BookingService()) {
		self.bookingService = bookingService
	}

	func execute(email: String,
				 lastName: String,
				 birthDate: Date,
				 reservationNumber: String,
				 reservationGuestID: String,
                 reCaptchaToken: String = "") async -> ClaimBookingUseCaseResult {
		let result = await bookingService.claimBooking(email: email,
													   lastName: lastName,
													   birthDate: birthDate,
													   reservationNumber: reservationNumber,
													   reservationGuestID: reservationGuestID,
                                                       reCaptchaToken: reCaptchaToken)

		return await handleClaimBookingResult(result)
	}

	func execute(email: String,
				 lastName: String,
				 birthDate: Date,
				 reservationNumber: String,
                 reCaptchaToken: String = "") async -> ClaimBookingUseCaseResult {
		let result = await bookingService.claimBooking(
			email: email,
			lastName: lastName,
			birthDate: birthDate,
			reservationNumber: reservationNumber,
            reCaptchaToken: reCaptchaToken
		)

		return await handleClaimBookingResult(result)
	}

	private func handleClaimBookingResult(_ result: ClaimBookingResult) async -> ClaimBookingUseCaseResult {
		switch result {
		case .success:
			return await reloadBooking() ? .success : .bookingNotFound
		case .successRequiresAuthentication:
			return .successRequiresAuthentication
		case .bookingNotFound:
			return .bookingNotFound
		case .emailConflict(let email, let reservationNumber, let reservationGuestID):
			return .emailConflict(email: email,
								  reservationNumber: reservationNumber,
								  reservationGuestID: reservationGuestID)
        case .guestConflict(let reservationNumber, let guestDetails):
            return .guestConflict(reservationNumber: reservationNumber, guestDetails: guestDetails)
		}
	}

	private func reloadBooking() async -> Bool {
		do {
			try await bookingService.reloadBooking()
			return true
		} catch {
			return false
		}
	}
}
