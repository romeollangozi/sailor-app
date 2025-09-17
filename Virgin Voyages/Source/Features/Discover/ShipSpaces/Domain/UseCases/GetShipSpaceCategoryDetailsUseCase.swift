//
//  GetShipSpaceCategoryDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 30.1.25.
//

import Foundation

protocol GetShipSpaceCategoryDetailsUseCaseProtocol {
    func execute(shipSpaceCategoryCode: String, useCache: Bool) async throws -> ShipSpaceCategoryDetails
}

final class GetShipSpaceCategoryDetailsUseCase: GetShipSpaceCategoryDetailsUseCaseProtocol {
    private let repository: GetShipSpaceCategoryDetailsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol

    init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(), repository: GetShipSpaceCategoryDetailsRepositoryProtocol = GetShipSpaceCategoryRepository()) {
        self.currentSailorManager = currentSailorManager
        self.repository = repository
    }
    
    func execute(shipSpaceCategoryCode: String, useCache: Bool = false) async throws -> ShipSpaceCategoryDetails {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        guard let response = try await repository.fetchShipSpaceCategoryDetails(shipSpaceCategoryCode: shipSpaceCategoryCode, guestId: currentSailor.reservationGuestId, shipCode: currentSailor.shipCode, useCache: useCache) else {
            throw VVDomainError.genericError
        }
        return response
    }
}

final class MockGetShipSpaceCategoryUseCase: GetShipSpaceCategoryDetailsUseCaseProtocol {
    func execute(shipSpaceCategoryCode: String, useCache: Bool = false) async throws -> ShipSpaceCategoryDetails {
        return ShipSpaceCategoryDetails.sample()
    }
}
