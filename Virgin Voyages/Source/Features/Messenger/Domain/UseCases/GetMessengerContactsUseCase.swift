//
//  GetContactListUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.10.24.
//

import Foundation

protocol GetMessengerContactsUseCaseProtocol {
    func execute(useCache: Bool) async throws -> MessengerContactsModel
}

class GetMessengerContactsUseCase: GetMessengerContactsUseCaseProtocol {
    
    // MARK: - Properties
    private let messengerContactRepository: MessengerContactsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    private let userProfilesRepository: UserProfileRepositoryProtocol
    private let localizationManager: LocalizationManagerProtocol
    
    // MARK: - Init
    init(messengerContactRepository: MessengerContactsRepositoryProtocol = MessengerContactsRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
         userProfilesRepository: UserProfileRepositoryProtocol = UserProfileRepository(),
         localizationManager: LocalizationManagerProtocol = LocalizationManager.shared) {
        self.messengerContactRepository = messengerContactRepository
        self.currentSailorManager = currentSailorManager
        self.userProfilesRepository = userProfilesRepository
        self.localizationManager = localizationManager
    }
    
    // MARK: - Execute
    func execute(useCache: Bool) async throws -> MessengerContactsModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        guard let messengerContacts = try await messengerContactRepository.getMessengerContacts(reservationId: currentSailor.reservationId, personId: currentSailor.reservationGuestId, useCache: useCache) else { throw VVDomainError.genericError }

        guard let userProfile = try await userProfilesRepository.getUserProfile() else { throw VVDomainError.genericError }
        
        let deepLink = DeepLinkGenerator.generate(reservationGuestId: currentSailor.reservationGuestId, reservationId: currentSailor.reservationId, voyageNumber: currentSailor.voyageNumber, name: userProfile.firstName)
        
        return MessengerContactsModel.map(messengerContacts: messengerContacts, user: userProfile, currentSailor: currentSailor, localization: localizationManager, deepLink: deepLink, shareText: "Ahoy! \(userProfile.firstName) a fellow sailor on your voyage would like to add you as a contact. Click here if you’d like to add your sailor mate in the app")
    }
    
}
