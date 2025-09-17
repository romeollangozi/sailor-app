//
//  GetCabinServiceContentUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/23/25.
//

import Foundation

protocol GetCabinServiceContentUseCaseProtocol: AnyObject {
    func execute() async throws -> CabinService
}


class GetCabinServiceContentUseCase: GetCabinServiceContentUseCaseProtocol {
    
    // MARK: - Properties
    private var cabinServiceRepository: CabinServiceRepositoryProtocol
    private var currentSailorManager: CurrentSailorManagerProtocol
    
    // MARK: - Init
    init(cabinServiceRepository: CabinServiceRepositoryProtocol = CabinServiceRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        
        self.cabinServiceRepository = cabinServiceRepository
        self.currentSailorManager = currentSailorManager
    }
    
    // MARK: - Execute
    func execute() async throws -> CabinService {
        
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        let shipCode = currentSailor.shipCode
        
        guard let cabinNumber = currentSailor.cabinNumber else { return CabinService.empty() }
        
        guard let cabinService = try await cabinServiceRepository.getCabinServiceContent(cabinNumber: cabinNumber,
                                                                                         shipCode: shipCode) else {
            
            throw VVDomainError.genericError
        }
        
        return cabinService
    }
    
}
