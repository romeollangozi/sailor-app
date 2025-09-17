//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 21.3.25.
//

protocol  GetHomePlannerUseCaseProtocol {
    func execute() async throws -> HomePlannerSection
}

final class GetHomePlannerUseCase: GetHomePlannerUseCaseProtocol {
    private let homePlannerRepository: HomePlannerRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(
        homePlannerRepository: HomePlannerRepositoryProtocol = HomePlannerRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.homePlannerRepository = homePlannerRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute() async throws -> HomePlannerSection {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        guard let response = try await homePlannerRepository.fetchHomePlanner(
            reservationGuestId: currentSailor.reservationGuestId,
            reservationNumber: currentSailor.reservationNumber,
            shipCode: currentSailor.shipCode,
            voyageNumber: currentSailor.voyageNumber
        ) else {
            throw VVDomainError.genericError
        }
        return response
    }
}
