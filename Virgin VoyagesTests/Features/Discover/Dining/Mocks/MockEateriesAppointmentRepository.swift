//
//  MockEateriesAppointmentRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockEateriesAppointmentRepository: EateriesAppointmentRepositoryProtocol {
	var shouldThrowError = false
	var mockResponse: EateryAppointmentDetails?
	
	func fetchEateryAppointmentDetails(appointmentId: String, reservationGuestId: String) async throws -> EateryAppointmentDetails? {
		if shouldThrowError {
			throw VVDomainError.genericError
		}
		
		return mockResponse
	}
}
