//
//  GetVoyageActivitiesContentUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/11/25.
//

import Foundation

protocol GetVoyageActivitiesContentUseCaseProtocol: AnyObject {
    func execute(sailingMode: String) async throws -> VoyageActivitiesSection
}

class GetVoyageActivitiesContentUseCase: GetVoyageActivitiesContentUseCaseProtocol {
    
    // MARK: - Properties
    private let voyageActivitiesRepository: VoyageActivitiesRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    // MARK: - Init
    init(voyageActivitiesRepository: VoyageActivitiesRepositoryProtocol = VoyageActivitiesRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.voyageActivitiesRepository = voyageActivitiesRepository
        self.currentSailorManager = currentSailorManager
    }
    
    // MARK: - Execute
    func execute(sailingMode: String) async throws -> VoyageActivitiesSection {
        
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        let shipCode = currentSailor.shipCode
        let reservationId = currentSailor.reservationId
        let reservationNumber = currentSailor.reservationNumber
        let reservationGuestId = currentSailor.reservationGuestId
        
        guard let voyageActivity = try await voyageActivitiesRepository.getVoyageActivitesContent(shipCode: shipCode,
                                                                                                  reservationId: reservationId,
                                                                                                  reservationNumber: reservationNumber,
                                                                                                  reservationGuestId: reservationGuestId,
                                                                                                  sailingMode: sailingMode) else {
            throw VVDomainError.genericError
        }
        
        return voyageActivity

    }
    
}
