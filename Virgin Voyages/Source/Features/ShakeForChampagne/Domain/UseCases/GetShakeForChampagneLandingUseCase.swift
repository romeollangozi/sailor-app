//
//  GetShakeForChampagneLandingUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/16/25.
//

import Foundation

protocol GetShakeForChampagneLandingUseCaseProtocol: AnyObject {
    func execute(orderId: String?) async throws -> ShakeForChampagne
}

class GetShakeForChampagneLandingUseCase: GetShakeForChampagneLandingUseCaseProtocol {
    
    // MARK: - Properties
    private var shakeForChampagneRepository: ShakeForChampagneRepositoryProtocol
    private var currentSailorManager: CurrentSailorManagerProtocol
    
    // MARK: - Init
    init(shakeForChampagneRepository: ShakeForChampagneRepositoryProtocol = ShakeForChampagneRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.shakeForChampagneRepository = shakeForChampagneRepository
        self.currentSailorManager = currentSailorManager
    }
    
    // MARK: - Execute
    func execute(orderId: String? = nil) async throws -> ShakeForChampagne {
        
        guard let currentSailor = currentSailorManager.getCurrentSailor() else {
            throw VVDomainError.unauthorized
        }
        
        let reservationGuestId = currentSailor.reservationGuestId
        
        guard let shakeForChampagneLanding = try await shakeForChampagneRepository.getShakeForChampageLandingContent(reservationGuestId: reservationGuestId, orderId: orderId) else {
            
            throw VVDomainError.genericError
            
        }
        
        return shakeForChampagneLanding
    }
    
}
