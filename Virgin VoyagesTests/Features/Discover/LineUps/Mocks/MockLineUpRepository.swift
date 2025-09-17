//
//  MockLineUpRepository.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/7/25.
//

import Foundation
@testable import Virgin_Voyages

final class MockLineUpRepository: LineUpRepositoryProtocol {

    var shouldThrowError: Bool = false
    var mockLineUpEvents: [LineUpEvents] = []
    var mockMustSeeEvents: [LineUpEvents] = []
    var mockLeadTime: LeadTime? = nil
    var mockLineUpAppointment: LineUpAppointment? = nil

	func fetchLineUp(reservationGuestId: String, startDateTime: String?, voyageNumber: String, reservationNumber: String, useCache: Bool) async throws -> LineUp {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return LineUp(events: mockLineUpEvents, mustSeeEvents: mockMustSeeEvents, leadTime: mockLeadTime)
    }

    func fetchLineUpAppointmentDetails(appointmentId: String, reservationGuestId: String) async throws -> LineUpAppointment? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        return mockLineUpAppointment
    }
	
	func fetchLineUpDetails(eventId: String, slotId: String, reservationGuestId: String, voyageNumber: String, reservationNumber: String, shipCode: String) async throws -> Virgin_Voyages.LineUpEvents.EventItem? {
		if shouldThrowError {
			throw VVDomainError.genericError
		}
		
		if mockLineUpEvents.isEmpty {
			return nil
		}
		
		return mockLineUpEvents[0].items.isEmpty ? nil : mockLineUpEvents[0].items[0]
	}
}
