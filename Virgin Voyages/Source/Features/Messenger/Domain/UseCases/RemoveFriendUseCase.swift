//
//  RemoveFriendUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 30.10.24.
//

protocol RemoveFriendUseCaseProtocol {
    func execute(connectionReservationId: String, connectionReservationGuestId: String) async throws -> Bool
}

class RemoveFriendUseCase: RemoveFriendUseCaseProtocol {
    private let repository: MessengerFriendsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
	private let sailorsRepository: SailorsRepositoryProtocol

    init(repository: MessengerFriendsRepositoryProtocol = MessengerFriendsRepository(), currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(), sailorsRepository: SailorsRepositoryProtocol = SailorsRepository()) {
        self.repository = repository
        self.currentSailorManager = currentSailorManager
		self.sailorsRepository = sailorsRepository
    }
    
    func execute(connectionReservationId: String, connectionReservationGuestId: String) async throws -> Bool {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        do {
            try await repository.removeFriendFromContacts(reservationId: currentSailor.reservationId, reservationGuestId: currentSailor.reservationGuestId, connectionResevationId: connectionReservationId,connectionReservationGuestId: connectionReservationGuestId)
			try await invalidateSailorsCache()
            return true
        } catch {
            return false
        }
    }

	//TODO: We need to to find way how to invalidate cache for GetMySailorsRequest
	private func invalidateSailorsCache() async throws {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		_ =  try await sailorsRepository.fetchMySailors(reservationGuestId: currentSailor.reservationGuestId, reservationNumber: currentSailor.reservationNumber, useCache: false)
	}
}
