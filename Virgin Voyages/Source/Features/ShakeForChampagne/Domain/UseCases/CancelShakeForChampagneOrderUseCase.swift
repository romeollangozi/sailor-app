//
//  CancelShakeForChampagneOrderUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/22/25.
//

import Foundation

protocol CancelShakeForChampagneOrderUseCaseProtocol {
    func execute(orderId: String) async throws -> CancelShakeForChampagneOrderRequestResult?
}

final class CancelShakeForChampagneOrderUseCase: CancelShakeForChampagneOrderUseCaseProtocol {
    
    private let shakeForChampagneRepository: ShakeForChampagneRepositoryProtocol
    
    init(shakeForChampagneRepository: ShakeForChampagneRepositoryProtocol = ShakeForChampagneRepository()) {
        
        self.shakeForChampagneRepository = shakeForChampagneRepository
    }
    
    func execute(orderId: String) async throws -> CancelShakeForChampagneOrderRequestResult? {
        
        return try await shakeForChampagneRepository.cancelShakeForChampagneOrder(orderId: orderId)
        
    }
}
