//
//  ShakeForChampagneRepository.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/16/25.
//

import Foundation

protocol ShakeForChampagneRepositoryProtocol {
    
    func getShakeForChampageLandingContent(reservationGuestId: String, orderId: String?) async throws -> ShakeForChampagne?
    func createShakeForChampagneOrder(input: CreateShakeForChampagneOrderRequestInput) async throws -> CreateShakeForChampagneOrderRequestResult
    func cancelShakeForChampagneOrder(orderId: String) async throws -> CancelShakeForChampagneOrderRequestResult?
    
}

final class ShakeForChampagneRepository: ShakeForChampagneRepositoryProtocol {
    
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getShakeForChampageLandingContent(reservationGuestId: String,
                                           orderId: String?) async throws -> ShakeForChampagne? {
        
        let response = try await networkService.getShakeForChampagneLanding(reservationGuestId: reservationGuestId,
                                                                            orderId: orderId)
        
        return response?.toDomain()
        
    }
    
    func createShakeForChampagneOrder(input: CreateShakeForChampagneOrderRequestInput) async throws -> CreateShakeForChampagneOrderRequestResult {
        
        let response = try await networkService.createShakeForChampagneOrder(request: input.toNetworkDto())
        return response.toDomain()
        
    }
    
    func cancelShakeForChampagneOrder(orderId: String) async throws -> CancelShakeForChampagneOrderRequestResult? {
        
        let response = try await networkService.cancelShakeForChampagneOrder(orderId: orderId)
        return response?.toDomain()
    }
    
}
