//
//  ProfileSettingsRepository.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 30.10.24.
//

import Foundation

protocol ProfileSettingsRepositoryProtocol {
    func getProfileSettingContent(reservationGuestId: String, reservationNumber: String, reservationId: String) async -> Result<ProfileSettingsLandingScreenModel, VVDomainError>
}

class ProfileSettingsRepository: ProfileSettingsRepositoryProtocol {
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
	func getProfileSettingContent(reservationGuestId: String, reservationNumber: String, reservationId: String) async -> Result<ProfileSettingsLandingScreenModel, VVDomainError> {
        
        let result = await networkService.fetchProfileSettingsLandingScreen(
            reservationID: reservationId,
            reservationNumber: reservationNumber,
			reservationGuestID: reservationGuestId
        )
        
        if let networkError = result.error {
            let domainError = NetworkToVVDomainErrorMapper.map(from: networkError)
            return .failure(domainError)
        }
        
        if let apiResult = result.response  {
			let contentModel = ProfileSettingsLandingScreenModel.mapProfileSettingsLandingScreenViewModel(from: apiResult)
            return .success(contentModel)
        }
        
        return .failure(.genericError)
    }
}

// MARK: Mock Preview

class MockPreviewProfileSettingsRepository: ProfileSettingsRepositoryProtocol {
    func getProfileSettingContent(reservationGuestId: String, reservationNumber: String, reservationId: String) async -> Result<ProfileSettingsLandingScreenModel, VVDomainError> {
        return .success(.init(
            content: .init(screenTitle: "Preview Profile Settings", screenDescription: "This is a preview of the Profile Settings screen.", imageUrl: ""),
            menuItems: [
                .init(
					id: ProfileSettingItemIdentifier.personalInformation,
                    title: "Personal Information",
                    description: "View and edit your account information.",
                    isEnabled: true,
                    sequence: 1
                ),
                .init(
					id: ProfileSettingItemIdentifier.termsAndConditions,
                    title: "Terms and Conditions",
                    description: "Read the terms and conditions.",
                    isEnabled: true,
                    sequence: 4
                ),
            ]
        ))
    }
}

