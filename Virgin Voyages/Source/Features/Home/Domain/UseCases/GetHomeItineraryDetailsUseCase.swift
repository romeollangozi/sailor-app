//
//  GetHomeItineraryDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Pajtim on 7.4.25.
//

import Foundation

protocol GetHomeItineraryDetailsUseCaseProtocol {
    func execute() async throws -> HomeItineraryDetails
}

class GetHomeItineraryDetailsUseCase: GetHomeItineraryDetailsUseCaseProtocol {
    private let repository: HomeItineraryDetailsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol


    init(repository: HomeItineraryDetailsRepositoryProtocol = HomeItineraryDetailsRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.repository = repository
        self.currentSailorManager = currentSailorManager
    }

    func execute() async throws -> HomeItineraryDetails {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        if let response = try await repository.getItineraryDetails(reservationGuestId: currentSailor.reservationGuestId, voyageNumber: currentSailor.voyageNumber, reservationNumber: currentSailor.reservationNumber) {
            return response
        } else {
            throw VVDomainError.genericError
        }
    }
}
