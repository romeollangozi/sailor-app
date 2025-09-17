//
//  BookingService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/11/24.
//

import Foundation

enum ClaimBookingResult {
	case success
	case successRequiresAuthentication
	case bookingNotFound
	case emailConflict(email: String, reservationNumber: String, reservationGuestID: String)
    case guestConflict(reservationNumber: String, guestDetails: [ClaimBookingGuestDetails])
}

protocol BookingServiceProtocol {
	func reloadBooking() async throws

	func claimBooking(email: String,
					  lastName: String,
					  birthDate: Date,
					  reservationNumber: String,
                      reCaptchaToken: String) async -> ClaimBookingResult

	func claimBooking(email: String,
					  lastName: String,
					  birthDate: Date,
					  reservationNumber: String,
					  reservationGuestID: String,
                      reCaptchaToken: String) async -> ClaimBookingResult
}

class BookingService: BookingServiceProtocol {

	let model = AuthenticationService.shared
    private let claimBookingRepository : ClaimBookingRepositoryProtocol
    
    init (claimBookingRepository: ClaimBookingRepositoryProtocol = ClaimBookingRepository()) {
        self.claimBookingRepository = claimBookingRepository
    }
    
	func reloadBooking() async throws {
        // TODO: Need to refactor model.reloadReservation()
		try await model.reloadReservation()
	}

	func claimBooking(email: String,
					  lastName: String,
					  birthDate: Date,
					  reservationNumber: String,
                      reCaptchaToken: String) async -> ClaimBookingResult {
		await internalClaimBooking(email: email,
								   lastName: lastName,
								   birthDate: birthDate,
								   reservationNumber: reservationNumber,
                                   reservationGuestID: nil,
                                   reCaptchaToken: reCaptchaToken
        )
	}

	func claimBooking(email: String,
					  lastName: String,
					  birthDate: Date,
					  reservationNumber: String,
					  reservationGuestID: String,
                      reCaptchaToken: String) async -> ClaimBookingResult {
		await internalClaimBooking(email: email,
								   lastName: lastName,
								   birthDate: birthDate,
								   reservationNumber: reservationNumber,
                                   reservationGuestID: reservationGuestID,
                                   reCaptchaToken: reCaptchaToken)
	}

	private func internalClaimBooking(email: String,
									  lastName: String,
									  birthDate: Date,
									  reservationNumber: String,
									  reservationGuestID: String? = nil,
                                      reCaptchaToken: String) async -> ClaimBookingResult {
        
        let dateOfBirth = birthDate.format(.iso8601date)
        let input = ClaimBookingRequestBody(
            lastName: lastName,
            reservationNumber: reservationNumber,
            birthDate: dateOfBirth,
            emailId: email,
            reservationGuestId: reservationGuestID,
            returnAllGuests: true,
            recaptchaToken: reCaptchaToken
        )
        
        guard let response = try? await claimBookingRepository.claimBooking(request: input) else {
            return .bookingNotFound
        }
        
		switch response.status {
		case .success:
			switch requiresAuthentication() {
			case true:
				return .successRequiresAuthentication
			case false:
				return .success
			}
		case .bookingNotFound:
			return .bookingNotFound
		case .emailConflict:
			let email = response.guestDetails.first?.email ?? ""
			let reservationGuestID = response.guestDetails.first?.reservationGuestID ?? ""
			let reservationNumber = response.guestDetails.first?.reservationNumber ?? ""
			return .emailConflict(email: email,
								  reservationNumber: reservationNumber,
								  reservationGuestID: reservationGuestID)
        case .guestConflict:
            let guestDetails = response.guestDetails
            return .guestConflict(reservationNumber: reservationNumber, guestDetails: guestDetails)
		case .unknown:
			return .bookingNotFound
		}
	}

	private func requiresAuthentication() -> Bool {
		guard let account = model.currentAccount else {
			return true
		}

		return account.status == .active ? false : true
	}
}
