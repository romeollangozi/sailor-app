//
//  CreateCabinServiceRequestUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//

protocol CreateCabinServiceRequestUseCaseProtocol {
    func execute(requestName: String, isMaintenance: Bool) async throws -> CreateCabinServiceRequestResult
}

final class CreateCabinServiceRequestUseCase: CreateCabinServiceRequestUseCaseProtocol {
	private let cabinServiceRepository: CabinServiceRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	
	init(cabinServiceRepository: CabinServiceRepositoryProtocol = CabinServiceRepository(), currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.cabinServiceRepository = cabinServiceRepository
		self.currentSailorManager = currentSailorManager
	}
	
    func execute(requestName: String, isMaintenance: Bool) async throws -> CreateCabinServiceRequestResult {
        
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let cabinNumber = currentSailor.cabinNumber, !cabinNumber.isEmpty else {
			throw VVDomainError.genericError
		}
        
        if isMaintenance {
            
            return try await cabinServiceRepository.createMaintenanceServiceRequest(input: .init(reservationGuestId: currentSailor.reservationGuestId, stateroom: cabinNumber, incidentCategoryCode: requestName), shipCode: currentSailor.shipCode)
            
        } else {
            
            return try await cabinServiceRepository.createCabinServiceRequest(input: .init(reservationId: currentSailor.reservationId, reservationGuestId: currentSailor.reservationGuestId, guestId: currentSailor.guestId, cabinNumber: cabinNumber, requestName: requestName))
            
        }
		
	}
}
