//
//  MessengerLandingScreenUseCase.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 23.10.24.
//

import Foundation

protocol MessengerLandingScreensUseCaseProtocol {
    func execute() async -> Result<MessengerLandingScreenModel, VVDomainError>
}

class MessengerLandingScreensUseCase: MessengerLandingScreensUseCaseProtocol {
    
    // MARK: - Repository
    private var localizationManagerService: LocalizationManagerProtocol
    private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol


    // MARK: - Init
    init(localizationManagerService: LocalizationManagerProtocol = LocalizationManager.shared, lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository(), currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.localizationManagerService = localizationManagerService
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
        self.currentSailorManager = currentSailorManager
    }
    
    // MARK: - Execute
    func execute() async -> Result<MessengerLandingScreenModel, VVDomainError> {

        let screenContent = createLabelsFromLocalizedStrings()
        let screenModel = MessengerLandingScreenModel(content: screenContent)

        return .success(screenModel)
    }
    
    
    private func createLabelsFromLocalizedStrings() -> MessengerLandingScreenContentModel {
        let screenTitle = localizationManagerService.getString(for: .messengerScreenTitle)
        let contactsButtonText = localizationManagerService.getString(for: .messengerContactAFriendButtonLabel)
        
        return .init(screenTitle: screenTitle,
                     welcomingText: welcomeText,
                     addFriendText: contactsButtonText
        )
    }

    private var welcomeText: String {
        let sailorLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
        return sailorLocation == .ship ? localizationManagerService.getString(for: .messengerEmptyWelcomeStateOnboard) : localizationManagerService.getString(for: .messengerEmptyWelcomeStatePreCruise)
    }
}
