//
//  GetSailingModeUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import Foundation

enum GetSailingModeUseCaseError: VVError {
	case failedToGetSailingMode
}

protocol GetSailingModeUseCaseProtocol {
    func execute() async throws -> SailingMode
}

class GetSailingModeUseCase: GetSailingModeUseCaseProtocol {
    private let myVoyageRepository: MyVoyageRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol

    init(myVoyageRepository: MyVoyageRepositoryProtocol = MyVoyageRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.myVoyageRepository = myVoyageRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute() async throws -> SailingMode {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        let reservationNumber = currentSailor.reservationNumber
        let reservationGuestId = currentSailor.reservationGuestId
        
        if let sailingMode = try await myVoyageRepository.fetchMyVoyageStatus(reservationNumber: reservationNumber, reservationGuestId: reservationGuestId) {
            return sailingMode
        } else {
			throw GetSailingModeUseCaseError.failedToGetSailingMode
        }
    }
}
