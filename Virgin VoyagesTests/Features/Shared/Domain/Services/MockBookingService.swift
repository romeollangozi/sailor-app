//
//  MockBookingService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 9/13/24.
//

import Foundation
@testable import Virgin_Voyages

enum MockBookingServiceError: Error {
	case anyError
}

class MockBookingService: BookingServiceProtocol {

	var claimBookingResult: ClaimBookingResult?
	var reloadBookingResult: Bool = true
	var shouldReloadThrowError: Bool = false

	func reloadBooking() async throws {
		if shouldReloadThrowError {
			throw MockBookingServiceError.anyError
		}
	}

	func claimBooking(email: String, lastName: String, birthDate: Date, reservationNumber: String) async -> ClaimBookingResult {
		return claimBookingResult ?? .bookingNotFound
	}

    func claimBooking(email: String, lastName: String, birthDate: Date, reservationNumber: String, reCaptchaToken reservationGuestID: String) async -> ClaimBookingResult {
		return claimBookingResult ?? .bookingNotFound
	}
    
    func claimBooking(email: String, lastName: String, birthDate: Date, reservationNumber: String, reservationGuestID: String, reCaptchaToken: String) async -> ClaimBookingResult {
        return claimBookingResult ?? .bookingNotFound
    }
}
