//
//  GetFolioUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 14.5.25.
//

import Foundation

protocol GetFolioUseCaseProtocol {
    func execute() async throws -> Folio
}

final class GetFolioUseCase: GetFolioUseCaseProtocol {
    private let folioRepository: FolioRepositoryProtocol
	private let myVoyageRepository: MyVoyageRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol

    init(
		folioRepository: FolioRepositoryProtocol = FolioRepository(),
		myVoyageRepository: MyVoyageRepositoryProtocol = MyVoyageRepository(),
        currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()
    ) {
        self.folioRepository = folioRepository
		self.myVoyageRepository = myVoyageRepository
        self.currentSailorManager = currentSailorManager
    }

    func execute() async throws -> Folio {
		guard let sailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let sailingMode = try await myVoyageRepository.fetchMyVoyageStatus(
			reservationNumber: sailor.reservationNumber,
			reservationGuestId: sailor.reservationGuestId
		) else {
			throw VVDomainError.genericError
		}

		guard let response = try await folioRepository.fetchFolio(
			sailingMode: sailingMode,
			reservationGuestId: sailor.reservationGuestId,
			reservationId: sailor.reservationId
		) else {
            throw VVDomainError.genericError
        }
        return response
    }
}
