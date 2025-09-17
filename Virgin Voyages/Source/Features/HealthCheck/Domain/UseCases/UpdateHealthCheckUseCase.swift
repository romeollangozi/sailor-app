//
//  UpdateHealthCheckUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/10/25.
//

import Foundation

protocol UpdateHealthCheckUseCaseProtocol {
    func execute(input: UpdateHealthCheckDetailRequestInput) async throws -> UpdateHealthCheckDetailRequestResult

}

final class UpdateHealthCheckUseCase: UpdateHealthCheckUseCaseProtocol {
    
    private let healthCheckRepository: HealthCheckRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(healthCheckRepository: HealthCheckRepositoryProtocol = HealthCheckRepository(),            currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        
        self.healthCheckRepository = healthCheckRepository
        self.currentSailorManager = currentSailorManager
    }
    
    
    func execute(input: UpdateHealthCheckDetailRequestInput) async throws -> UpdateHealthCheckDetailRequestResult {
        
        guard let currentSailor = currentSailorManager.getCurrentSailor() else {
            throw VVDomainError.unauthorized
        }
        
        return try await healthCheckRepository.updateHealthCheckDetailContent(input: input,
                                                                              reservationGuestId: currentSailor.reservationGuestId,
                                                                              reservationId: currentSailor.reservationId)
    }
    
}
