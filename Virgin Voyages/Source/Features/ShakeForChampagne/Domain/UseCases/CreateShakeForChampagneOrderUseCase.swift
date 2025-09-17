//
//  CreateShakeForChampagneOrderUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/21/25.
//

import Foundation

protocol CreateShakeForChampagneOrderUseCaseProtocol {
    func execute(quantity: Int) async throws -> CreateShakeForChampagneOrderRequestResult
}

final class CreateShakeForChampagneOrderUseCase: CreateShakeForChampagneOrderUseCaseProtocol {
    
    private let shakeForChampagneRepository: ShakeForChampagneRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(shakeForChampagneRepository: ShakeForChampagneRepositoryProtocol = ShakeForChampagneRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        
        self.shakeForChampagneRepository = shakeForChampagneRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute(quantity: Int) async throws -> CreateShakeForChampagneOrderRequestResult {
        
        guard let currentSailor = currentSailorManager.getCurrentSailor() else {
            throw VVDomainError.unauthorized
        }
        
        return try await shakeForChampagneRepository.createShakeForChampagneOrder(input: .init(reservationGuestId: currentSailor.reservationGuestId, quantity: quantity))
        
    }
    
}
