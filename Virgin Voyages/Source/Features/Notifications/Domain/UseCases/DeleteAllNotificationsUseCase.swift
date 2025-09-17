//
//  DeleteAllNotificationsUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 1.5.25.
//

import Foundation

protocol DeleteAllNotificationsUseCaseProtocol {
    func execute() async throws
}

final class DeleteAllNotificationsUseCase: DeleteAllNotificationsUseCaseProtocol {
    private let deleteAllNotificationsRepository: DeleteAllNotificationsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol

    init(
        currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
        deleteAllNotificationsRepository: DeleteAllNotificationsRepositoryProtocol = DeleteAllNotificationsRepository()
    ) {
        self.currentSailorManager = currentSailorManager
        self.deleteAllNotificationsRepository = deleteAllNotificationsRepository
    }

    func execute() async throws {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        let reservationGuestId = currentSailor.reservationGuestId
        let voyageNumber = currentSailor.voyageNumber
        
        guard let _ = try await deleteAllNotificationsRepository.deleteAllNotifications(
            reservationGuestId: reservationGuestId,
            voyageNumber: voyageNumber
        ) else {
            throw VVDomainError.genericError
        }
    }
}
