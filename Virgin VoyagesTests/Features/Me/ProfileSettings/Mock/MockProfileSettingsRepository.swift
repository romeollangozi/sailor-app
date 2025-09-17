//
//  MockProfileSettingsRepository.swift
//  Virgin VoyagesTests
//
//  Created by Timur Xhabiri on 31.10.24.
//

import XCTest
@testable import Virgin_Voyages

class MockProfileSettingsRepository: ProfileSettingsRepositoryProtocol {
    var shouldReturnError = false
    var mockMenuItems: [ProfileSettingsMenuListItemModel] = []
    
    func getProfileSettingContent(reservationGuestId: String, reservationNumber: String, reservationId: String) async -> Result<ProfileSettingsLandingScreenModel, VVDomainError> {
        if shouldReturnError {
            return .failure(.genericError)
        } else {
            let mockContent = ProfileSettingsLandingScreenModel(
                content: ProfileSettingsLandingScreenModel.ContentModel(
                    screenTitle: "Test Screen",
                    screenDescription: "Test Description",
                    imageUrl: ""
                ),
                menuItems: mockMenuItems
            )
            return .success(mockContent)
        }
    }
}
