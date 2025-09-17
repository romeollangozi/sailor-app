//
//  GetUserShoresideOrShipsideLocationUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 25.11.24.
//

import Foundation

protocol GetUserShoresideOrShipsideLocationUseCaseProtocol {
    func execute() -> SailorLocation
}

class GetUserShoresideOrShipsideLocationUseCase: GetUserShoresideOrShipsideLocationUseCaseProtocol {

	private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol

    init(lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository()) {
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
    }
    
    func execute() -> SailorLocation {
		return self.lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
    }
}
