//
//  GetEateriesUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 23.11.24.
//

protocol GetEateriesListUseCaseProtocol {
	func execute(includePortsName: Bool, useCache: Bool) async throws -> EateriesList
}

final class GetEateriesListUseCase: GetEateriesListUseCaseProtocol {
    private let eateriesListRepository: EateriesListRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol

    init(eateriesListRepository: EateriesListRepositoryProtocol = EateriesListRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.eateriesListRepository = eateriesListRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute(includePortsName: Bool, useCache: Bool) async throws -> EateriesList {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let response = try await eateriesListRepository.fetchEateries(reservationId: currentSailor.reservationId, reservationGuestId: currentSailor.reservationGuestId, shipCode: currentSailor.shipCode, shipName: currentSailor.shipName, reservationNumber: currentSailor.reservationNumber, includePortsName: includePortsName, useCache: useCache) else { throw VVDomainError.genericError }

        return response
    }
}
