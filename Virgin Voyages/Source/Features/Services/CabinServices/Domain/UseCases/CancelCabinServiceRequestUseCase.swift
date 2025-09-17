//
//  CancelCabinServiceRequestUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.4.25.
//

protocol CancelCabinServiceRequestUseCaseProtocol {
    func execute(requestId: String, requestName: String, isMaintenance: Bool) async throws -> CancelCabinServiceRequestResult?
}

final class CancelCabinServiceRequestUseCase: CancelCabinServiceRequestUseCaseProtocol {
	private let cabinServiceRepository: CabinServiceRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	
	init(cabinServiceRepository: CabinServiceRepositoryProtocol = CabinServiceRepository(), currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.cabinServiceRepository = cabinServiceRepository
		self.currentSailorManager = currentSailorManager
	}
	
	func execute(requestId: String, requestName: String, isMaintenance: Bool) async throws -> CancelCabinServiceRequestResult? {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let cabinNumber = currentSailor.cabinNumber, !cabinNumber.isEmpty else {
			throw VVDomainError.genericError
		}
        
        if isMaintenance {
            
            return try await cabinServiceRepository.cancelMaintenanceServiceRequest(input: .init(incidentId: requestId,
                                                                                                 incidentCategoryCode: requestName,
                                                                                                 stateroom: cabinNumber,
                                                                                                 reservationGuestId: currentSailor.reservationGuestId),
                                                                                    shipCode: currentSailor.shipCode)!
            
        } else {
            
            return try await cabinServiceRepository.cancelCabinServiceRequest(input: .init(requestId: requestId,
                                                                                           cabinNumber: cabinNumber,
                                                                                           activeRequest: requestName))
        }
		
	}
}
