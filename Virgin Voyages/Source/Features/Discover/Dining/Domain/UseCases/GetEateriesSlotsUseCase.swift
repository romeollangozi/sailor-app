//
//  GetEateriesSlotsUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 25.11.24.
//

protocol GetEateriesSlotsUseCaseProtocol {
	func execute(input: EateriesSlotsInputModel) async throws -> EateriesSlots
}

final class GetEateriesSlotsUseCase: GetEateriesSlotsUseCaseProtocol {
    private let eateriesListRepository: EateriesSlotsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
   
    
    init(eateriesListRepository: EateriesSlotsRepositoryProtocol = EateriesSlotsRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.eateriesListRepository = eateriesListRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute(input: EateriesSlotsInputModel) async throws -> EateriesSlots {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        let input = EateriesSlotsInput(voyageNumber: currentSailor.voyageNumber,
                                       voyageId: currentSailor.voyageId,
                                       searchSlotDate: input.searchSlotDate.toYearMMdd(),
                                       embarkDate: currentSailor.embarkDate,
                                       debarkDate: currentSailor.debarkDate,
                                       mealPeriod: input.mealPeriod,
                                       shipCode: currentSailor.shipCode,
                                       guestCount: input.guests.count,
                                       venues: input.venues.map({.init(externalId: $0.externalId, venueId: $0.venueId)}),
									   reservationNumber: currentSailor.reservationNumber,
                                       reservationGuestId: currentSailor.reservationGuestId)
        
        guard let response = try await eateriesListRepository.fetchEateriesSlots(input: input)  else { throw VVDomainError.genericError }
        
		return response
    }
}


