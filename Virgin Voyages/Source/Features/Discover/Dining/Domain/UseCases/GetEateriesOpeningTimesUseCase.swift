//
//  GetEateriesOpeningTimes.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 3.12.24.
//

import Foundation

protocol GetEateriesOpeningTimesUseCaseProtocol {
    func execute(date: Date) async throws -> EateriesOpeningTimesModel
}

final class GetEateriesOpeningTimesUseCase: GetEateriesOpeningTimesUseCaseProtocol {
    private let eateriesOpeningTimesRepository: EateriesOpeningTimesRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    private let eateriesListRepository: EateriesListRepositoryProtocol
    private let localizationManager: LocalizationManagerProtocol
    var labels: EateriesOpeningTimesModel.Labels

    init(eateriesOpeningTimesRepository: EateriesOpeningTimesRepositoryProtocol = EateriesOpeningTimesRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
         eateriesListRepository: EateriesListRepositoryProtocol = EateriesListRepository(),
         localizationManager: LocalizationManagerProtocol = LocalizationManager.shared) {
        self.eateriesOpeningTimesRepository = eateriesOpeningTimesRepository
        self.currentSailorManager = currentSailorManager
        self.eateriesListRepository = eateriesListRepository
        self.localizationManager = localizationManager

        self.labels = EateriesOpeningTimesModel.Labels(
            openingTimesUnavailable: localizationManager.getString(for: .openingTimesUnavailable),
            closedText: localizationManager.getString(for: .closedText)
        )
    }
    
    func execute(date: Date) async throws -> EateriesOpeningTimesModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        guard let openingTimes = try await eateriesOpeningTimesRepository.fetchEateriesOpeningTimes(reservationId: currentSailor.reservationId, reservationGuestId: currentSailor.reservationGuestId, shipCode: currentSailor.shipCode, reservationNumber: currentSailor.reservationNumber, selectedDate: date.toYearMMdd()) else { throw VVDomainError.genericError }
        
		guard let eateriesList = try await eateriesListRepository.fetchEateries(reservationId: currentSailor.reservationId, reservationGuestId: currentSailor.reservationGuestId, shipCode: currentSailor.shipCode, shipName: currentSailor.shipName, reservationNumber: currentSailor.reservationNumber, includePortsName: false) else { throw VVDomainError.genericError }
        
        return EateriesOpeningTimesModel.map(eateriesOpeningTimes: openingTimes, eateriesList: eateriesList, labels: self.labels)
    }
}
