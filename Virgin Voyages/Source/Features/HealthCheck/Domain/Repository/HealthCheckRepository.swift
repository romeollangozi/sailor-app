//
//  HealthCheckRepository.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/2/25.
//

import Foundation

protocol HealthCheckRepositoryProtocol {
    
    func getHealthCheckDetailContent(reservationGuestId: String,
                                     reservationId: String) async throws -> HealthCheckDetail?
    
    func updateHealthCheckDetailContent(input: UpdateHealthCheckDetailRequestInput,
                                        reservationGuestId: String,
                                        reservationId: String) async throws -> UpdateHealthCheckDetailRequestResult
    
}

final class HealthCheckRepository: HealthCheckRepositoryProtocol {
    
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getHealthCheckDetailContent(reservationGuestId: String,
                                     reservationId: String) async throws -> HealthCheckDetail? {
        
        let response = try await networkService.getHealthCheckDetail(reservationGuestId: reservationGuestId,
                                                                     reservationId: reservationId)
        
        return response?.toDomain()
    }
    
    func updateHealthCheckDetailContent(input: UpdateHealthCheckDetailRequestInput,
                                        reservationGuestId: String,
                                        reservationId: String) async throws -> UpdateHealthCheckDetailRequestResult {
        
        let response = try await networkService.updateHealthCheckDetail(input: input.toNetworkDto(),
                                                                        reservationGuestId: reservationGuestId,
                                                                        reservationId: reservationId)
        
        return response.toDomain()
    }
    
}
