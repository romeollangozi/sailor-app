//
//  GetHomeComingGuideUseCase.swift
//  Virgin Voyages
//
//  Created by Pajtim on 2.4.25.
//

import Foundation

protocol GetHomeComingGuideUseCaseProtocol {
    func execute() async throws -> HomeComingGuide
}

class GetHomeComingGuideUseCase: GetHomeComingGuideUseCaseProtocol {
    private let repository: HomeComingGuideRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol


    init(repository: HomeComingGuideRepositoryProtocol = HomeComingGuideRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.repository = repository
        self.currentSailorManager = currentSailorManager
    }

    func execute() async throws -> HomeComingGuide {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		if let response = try await repository.getHomeComingGuide(reservationGuestId: currentSailor.reservationGuestId,
																  reservationId: currentSailor.reservationId,
																  debarkDate: currentSailor.debarkDate,
																  shipCode: currentSailor.shipCode,
																  voyageNumber: currentSailor.voyageNumber) {
            return response
        } else {
            throw VVDomainError.genericError
        }
    }
}
