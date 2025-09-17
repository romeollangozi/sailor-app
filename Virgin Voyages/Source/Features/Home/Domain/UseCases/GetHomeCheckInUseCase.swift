//
//  GetHomeCheckInUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 18.3.25.
//

protocol GetHomeCheckInUseCaseProtocol {
    func execute() async throws -> HomeCheckInSection
}

class GetHomeCheckInUseCase: GetHomeCheckInUseCaseProtocol {
    private let repository: HomePageRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    

    init(repository: HomePageRepositoryProtocol = HomePageRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.repository = repository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute() async throws -> HomeCheckInSection {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        if let response = try await repository.fetchHomePageCheckIn(reservationNumber: currentSailor.reservationNumber, reservationGuestId: currentSailor.reservationGuestId) {
            return response
        } else {
            throw VVDomainError.genericError
        }
    }
}
