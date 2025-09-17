//
//  CreateBeaconUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/8/25.
//

import Foundation

protocol CreateBeaconUseCaseProtocol {
    func execute(beaconId: String?) async throws -> Bool
}

final class CreateBeaconUseCase: CreateBeaconUseCaseProtocol {
    
    private let beaconRepository: BeaconRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(beaconRepository: BeaconRepositoryProtocol = BeaconRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        
        self.beaconRepository = beaconRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute(beaconId: String? = nil) async throws -> Bool {
        
        guard let currentSailor = currentSailorManager.getCurrentSailor() else {
            throw VVDomainError.unauthorized
        }
        
        let result = try await beaconRepository.createBeacon(input:
                .init(reservationGuestId: currentSailor.reservationGuestId,
                      beaconId: beaconId)
        )
        
        return result
        
    }
    
}
