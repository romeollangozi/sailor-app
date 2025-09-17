//
//  GetProfileSettingsLandingScreenUseCase.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 30.10.24.
//

import Foundation


protocol GetProfileSettingsLandingScreenUseCaseProtocol: AnyObject {
    func execute() async -> Result<ProfileSettingsLandingScreenModel, VVDomainError>
}

class GetProfileSettingsLandingScreenUseCase: GetProfileSettingsLandingScreenUseCaseProtocol {
	private let currentSailorManager: CurrentSailorManagerProtocol
    private var profileSettingsRepository: ProfileSettingsRepositoryProtocol
	private let lastKnownSailorConnectionLocationRepository : LastKnownSailorConnectionLocationRepositoryProtocol
	private let localizationManager: LocalizationManagerProtocol = LocalizationManager.shared

    // MARK: - Init
	init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 profileSettingsRepository: ProfileSettingsRepositoryProtocol = ProfileSettingsRepository(),
		 lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository()) {
		self.currentSailorManager = currentSailorManager
		self.profileSettingsRepository = profileSettingsRepository
		self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
	}
        
    // MARK: - Execute
    func execute() async -> Result<ProfileSettingsLandingScreenModel, VVDomainError> {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			return .failure(.unauthorized)
		}

		let sailorLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()

		let result = await profileSettingsRepository.getProfileSettingContent(reservationGuestId: currentSailor.reservationGuestId,
																			  reservationNumber: currentSailor.reservationNumber,
																			  reservationId: currentSailor.reservationId)
        
		switch result {
        case .success(let content):
            // Restrict menus on front end. This is temporary
            var mutableContent = content
			mutableContent.updateMenuItems(restrictMenuItems(content.menuItems, isOnShip: sailorLocation == .ship))
            return .success(mutableContent)
        case .failure(let error):
            return .failure(error)
        }
    }
    
	private func restrictMenuItems(_ menuItems: [ProfileSettingsMenuListItemModel], isOnShip: Bool) -> [ProfileSettingsMenuListItemModel] {
		var result: [ProfileSettingsMenuListItemModel] = []

		//Add Set Casino Pin manually
		if lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation() == .ship {
			result.append(.init(id: .setCasinoPin,
								title: localizationManager.getString(for: .casinoPinListingTitle),
								description: localizationManager.getString(for: .casinoPinListingDescription) ,
								sequence: -1))
		}

		for item in menuItems {
			let shouldShow = item.id == .termsAndConditions || (!isOnShip && item.id == .switchVoyage)
			if shouldShow {
				result.append(item)
			}
		}
		return result.sorted { $0.sequence < $1.sequence }
	}
}
