//
//  VoyageActivitiesRepository.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/11/25.
//

import Foundation

protocol VoyageActivitiesRepositoryProtocol {
    func getVoyageActivitesContent(shipCode: String,
                                   reservationId: String,
                                   reservationNumber: String,
                                   reservationGuestId: String,
                                   sailingMode: String) async throws -> VoyageActivitiesSection?
}

final class VoyageActivitiesRepository: VoyageActivitiesRepositoryProtocol {
    
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getVoyageActivitesContent(shipCode: String,
                                   reservationId: String,
                                   reservationNumber: String,
                                   reservationGuestId: String,
                                   sailingMode: String) async throws -> VoyageActivitiesSection? {
        
        if let response = try await networkService.getPlanAndBookContent(shipCode: shipCode,
                                                                         reservationId: reservationId,
                                                                         reservationNumber: reservationNumber,
                                                                         reservationGuestId: reservationGuestId,
                                                                         sailingMode: sailingMode) {
            
            return response.toDomain()
        } else {
            return nil
        }
    
    }
}
