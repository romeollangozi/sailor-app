//
//  GetHomeNotificationsUseCase.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 11.3.25.
//

protocol  GetHomeNotificationsUseCaseProtocol {
    func execute() async throws -> HomeNotificationsSection
}

final class GetHomeNotificationsUseCase: GetHomeNotificationsUseCaseProtocol {
    private let homeNotificationsRepository: HomeNotificationsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(
        homeNotificationsRepository: HomeNotificationsRepositoryProtocol = HomeNotificationsRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.homeNotificationsRepository = homeNotificationsRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute() async throws -> HomeNotificationsSection {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        guard let response = try await homeNotificationsRepository.fetchHomeNotification(reservationGuestId: currentSailor.reservationGuestId, reservationNumber: currentSailor.reservationNumber, voyageNumber: currentSailor.voyageNumber
        ) else {
			return .empty()
        }
        return response
    }
}
