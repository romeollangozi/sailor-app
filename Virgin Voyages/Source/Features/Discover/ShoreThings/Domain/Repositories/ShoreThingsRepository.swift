//
//  ActivityAppointmentDetailsRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 22.11.24.
//

import Foundation

protocol ShoreThingsRepositoryProtocol {
	func fetchActivityAppointmentDetails(appointmentId: String) async throws -> ShoreThingsAppointmentDetails?
	func fetchReceiptDetails(appointmentId: String) async throws -> ShoreThingReceiptDetails?
	func fetchShoreThingsList(portCode: String, startDate: Date, endDate: Date, reservationGuestId: String, voyageNumber: String, reservationNumber: String, useCache: Bool) async throws -> ShoreThingsList?
	func fetchShoreThingItem(id: String, slotId: String, portCode: String, portStartDate: String, portEndDate: String, reservationGuestId: String, voyageNumber: String, reservationNumber: String) async throws -> ShoreThingItem?
	func fetchShoreThingPorts(reservationId: String, reservationGuestId: String, shipCode: String, voyageNumber: String, useCache: Bool) async throws -> ShoreThingPorts?
}

final class ShoreThingsRepository: ShoreThingsRepositoryProtocol {
	private let networkService: NetworkServiceProtocol
	private let currentSailorManager: CurrentSailorManager
	
	init(networkService: NetworkServiceProtocol = NetworkService.create(),
		 currentSailorManager: CurrentSailorManager = CurrentSailorManager()) {
		self.networkService = networkService
		self.currentSailorManager = currentSailorManager
	}
	
	func fetchActivityAppointmentDetails(appointmentId: String) async throws -> ShoreThingsAppointmentDetails? {
		guard let response = try await networkService.getGetActivityAppointmentDetails(appointmentId: appointmentId) else { return nil }
		
		return ShoreThingsAppointmentDetails.map(from: response)
	}
	
	func fetchReceiptDetails(appointmentId: String) async throws -> ShoreThingReceiptDetails? {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		let response = try await networkService.getShoreThingReceiptDetails(appointmentId: appointmentId)
		
		return response?.toDomain(reservationGuestId: currentSailor.reservationGuestId)
	}
	
	func fetchShoreThingsList(portCode: String, startDate: Date, endDate: Date, reservationGuestId: String, voyageNumber: String, reservationNumber: String, useCache: Bool) async throws -> ShoreThingsList? {
		let response = try await networkService.getShoreThingsList( portCode: portCode,
																	startDate: startDate.toISO8601(),
																   endDate: endDate.toISO8601(),
																   reservationGuestId: reservationGuestId,
																   voyageNumber: voyageNumber,
																	reservationNumber: reservationNumber,
																   cacheOption: .timedCache(forceReload: !useCache))
		
		return response?.toDomain()
	}
	
	func fetchShoreThingItem(id: String, slotId: String, portCode: String, portStartDate: String, portEndDate: String, reservationGuestId: String, voyageNumber: String, reservationNumber: String) async throws -> ShoreThingItem? {
		let response = try await networkService.getShoreThingItem(id: id,
																  slotId: slotId,
																  startDate: portStartDate,
																  endDate: portEndDate,
																  portCode: portCode,
																  reservationGuestId: reservationGuestId,
																  voyageNumber: voyageNumber,
																  reservationNumber: reservationNumber
		)
		
		return response?.toDomain()
	}
    
	func fetchShoreThingPorts(reservationId: String, reservationGuestId: String, shipCode: String, voyageNumber: String, useCache: Bool) async throws -> ShoreThingPorts? {
        let response = try await networkService.getShoreThingPorts(
            reservationId: reservationId,
            reservationGuestId: reservationGuestId,
            shipCode: shipCode,
			voyageNumber: voyageNumber,
			cacheOption: .timedCache(forceReload: !useCache)
        )
        
        return response?.toDomain()
    }
    
}
