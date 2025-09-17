//
//  GetShipSpacesCategoriesUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 29.1.25.
//

import Foundation

protocol GetShipSpacesCategoriesUseCaseProtocol {
    func execute(useCache: Bool) async throws -> ShipSpacesCategories
}

final class GetShipSpacesCategoriesUseCase: GetShipSpacesCategoriesUseCaseProtocol {
    private let currentSailorManager: CurrentSailorManagerProtocol
    private let shipSpacesRepository: GetShipSpacesCategoriesRepositoryProtocol

    init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(), shipSpacesRepository: GetShipSpacesCategoriesRepositoryProtocol = GetShipSpacesRepository()) {
        self.currentSailorManager = currentSailorManager
        self.shipSpacesRepository = shipSpacesRepository
    }
    
    func execute(useCache: Bool = false) async throws -> ShipSpacesCategories {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
		guard let response = try await shipSpacesRepository.fetchShipSpaces(reservationId: currentSailor.reservationId, guestId: currentSailor.reservationGuestId, shipCode: currentSailor.shipCode, useCache: useCache) else { throw VVDomainError.genericError }
        return response
    }
}
