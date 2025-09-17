//
//  MockActivityAppointmentDetailsRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 22.11.24.
//

@testable import Virgin_Voyages
import Foundation

class MockShoreThingsRepository: ShoreThingsRepositoryProtocol {
	
    var fetchActivityAppointmentDetailsResult: ShoreThingsAppointmentDetails?
    var shouldThrowError: Bool = false
	var mockReceiptDetails: ShoreThingReceiptDetails? = nil
	var mockShoreThingsList: ShoreThingsList? = nil
	var mockShoreThingItem: ShoreThingItem? = nil
    var mockShoreThingPorts: ShoreThingPorts? = nil
	
    func fetchActivityAppointmentDetails(appointmentId: String) async throws -> ShoreThingsAppointmentDetails? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return fetchActivityAppointmentDetailsResult
    }
	
	func fetchReceiptDetails(appointmentId: String) async throws -> Virgin_Voyages.ShoreThingReceiptDetails? {
		if shouldThrowError {
			throw VVDomainError.genericError
		}
		
		return mockReceiptDetails
	}
	
	func fetchShoreThingsList(portCode: String, startDate: Date, endDate: Date, reservationGuestId: String, voyageNumber: String, reservationNumber: String, useCache: Bool) async throws -> Virgin_Voyages.ShoreThingsList? {
		if shouldThrowError {
			throw VVDomainError.genericError
		}
		
		return mockShoreThingsList
	}

	func fetchShoreThingItem(id: String, slotId: String, portCode: String, portStartDate: String, portEndDate: String, reservationGuestId: String, voyageNumber: String, reservationNumber: String) async throws -> Virgin_Voyages.ShoreThingItem? {
		if shouldThrowError {
			throw VVDomainError.genericError
		}
		
		return mockShoreThingItem
	}
	
	func fetchShoreThingPorts(reservationId: String, reservationGuestId: String, shipCode: String, voyageNumber: String, useCache: Bool) async throws -> ShoreThingPorts? {
        if shouldThrowError {
            throw VVDomainError.genericError
        }
        
        return mockShoreThingPorts
    }
}
