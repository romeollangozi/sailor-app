//
//  AddContactUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.11.24.
//

protocol AddContactUseCaseProtocol {
    func execute(connectionPersonId: String, isEventVisibleCabinMates: Bool) async -> Result<EmptyModel, VVDomainError>
}

class AddContactUseCase: AddContactUseCaseProtocol {
    
    // MARK: - Private properties
    private let repository: MessengerFriendsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    // MARK: - Init
    init(repository: MessengerFriendsRepositoryProtocol = MessengerFriendsRepository(), currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.repository = repository
        self.currentSailorManager = currentSailorManager
    }
    
    // MARK: - Execute
    func execute(connectionPersonId: String, isEventVisibleCabinMates: Bool) async -> Result<EmptyModel, VVDomainError> {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			return .failure(.unauthorized)
		}

		return await repository.addContacts(reservationId: currentSailor.reservationId, personId: currentSailor.reservationGuestId, connectionPersonId: connectionPersonId, isEventVisibleCabinMates: isEventVisibleCabinMates)
    }
}
