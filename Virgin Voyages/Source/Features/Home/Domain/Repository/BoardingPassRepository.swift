//
//  BoardingPassRepository.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/2/25.
//

import Foundation

protocol BoardingPassRepositoryProtocol {
    func getBoardingPassContent(reservationNumber: String,
                                reservationGuestId: String,
                                shipCode: String) async throws -> SailorBoardingPass?
}

final class BoardingPassRepository: BoardingPassRepositoryProtocol {
    
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getBoardingPassContent(reservationNumber: String,
                                reservationGuestId: String,
                                shipCode: String) async throws -> SailorBoardingPass? {
        
        if let response = try await networkService.getBoardingPassContent(reservationNumber: reservationNumber, reservationGuestId: reservationGuestId, shipCode: shipCode) {
            
            return response.toDomain()
        } else {
            return nil
        }
        
    }
    
}
