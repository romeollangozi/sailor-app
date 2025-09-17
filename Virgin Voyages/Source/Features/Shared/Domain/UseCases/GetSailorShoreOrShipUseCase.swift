//
//  GetSailorShoreOrShipUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.1.25.
//

protocol GetSailorShoreOrShipUseCaseProtocol {
    func execute() -> SailorShoreOrShipModel
}

final class GetSailorShoreOrShipUseCase: GetSailorShoreOrShipUseCaseProtocol {
    private let lastKnownSailorConnectionLocationRepository : LastKnownSailorConnectionLocationRepositoryProtocol

    init(lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository()) {
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
    }
    
    func execute() -> SailorShoreOrShipModel {
		let sailorLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
		let model = SailorShoreOrShipModel(isOnShip: sailorLocation == .ship)
        return model
    }
}
