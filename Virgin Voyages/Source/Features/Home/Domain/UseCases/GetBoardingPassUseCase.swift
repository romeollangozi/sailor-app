//
//  GetBoardingPassUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 4/2/25.
//

import Foundation

protocol GetBoardingPassUseCaseProtocol: AnyObject {
    func execute() async throws -> SailorBoardingPass
}

class GetBoardingPassUseCase: GetBoardingPassUseCaseProtocol {
    
    // MARK: - Properties
    private let boardingPassRepository: BoardingPassRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    // MARK: - Init
    init(boardingPassRepository: BoardingPassRepositoryProtocol = BoardingPassRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.boardingPassRepository = boardingPassRepository
        self.currentSailorManager = currentSailorManager
    }
    
    // MARK: - Execute
    func execute() async throws -> SailorBoardingPass {
        
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        let reservationNumber = currentSailor.reservationNumber
        let reservationGuestId = currentSailor.reservationGuestId
        let shipCode = currentSailor.shipCode
        
        guard let sailortBoardingPass = try await boardingPassRepository.getBoardingPassContent(reservationNumber: reservationNumber,
                                                                                                reservationGuestId: reservationGuestId,
                                                                                                shipCode: shipCode) else {
            throw VVDomainError.genericError
        }
        
        return sailortBoardingPass.prioritized(by: reservationGuestId)
    }
    
}
