//
//  ClearBeaconUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/12/25.
//

import Foundation

protocol ClearBeaconUseCaseProtocol {
    func execute() async throws
}

final class ClearBeaconUseCase: ClearBeaconUseCaseProtocol {
    
    private let beaconRepository: BeaconRepositoryProtocol

    init(beaconRepository: BeaconRepositoryProtocol = BeaconRepository()) {
        
        self.beaconRepository = beaconRepository
    }
    
    func execute() async throws {
        beaconRepository.clearBeaconId()
    }
}
