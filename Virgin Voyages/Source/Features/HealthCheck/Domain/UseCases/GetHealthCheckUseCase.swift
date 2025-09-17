//
//  GetHealthCheckUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/3/25.
//

import Foundation

protocol GetHealthCheckUseCaseProtocol: AnyObject {
    func execute() async throws -> HealthCheckDetail
}

class GetHealthCheckUseCase: GetHealthCheckUseCaseProtocol {
    
    // MARK: - Properties
    private var homeHealthCheckRepository: HealthCheckRepositoryProtocol
    private var currentSailorManager: CurrentSailorManagerProtocol
    
    // MARK: - Init
    init(homeHealthCheckRepository: HealthCheckRepositoryProtocol = HealthCheckRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        
        self.homeHealthCheckRepository = homeHealthCheckRepository
        self.currentSailorManager = currentSailorManager
    }
    
    // MARK: - Execute
    func execute() async throws -> HealthCheckDetail {
        
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        let reservationGuestId = currentSailor.reservationGuestId
        let reservationId = currentSailor.reservationId
        
        guard let homeHealthCheckDetail = try await homeHealthCheckRepository.getHealthCheckDetailContent(reservationGuestId: reservationGuestId,
                                                                                                          reservationId: reservationId) else {
             
            throw VVDomainError.genericError
        }
        
        return homeHealthCheckDetail
    }
    
}
