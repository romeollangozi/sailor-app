//
//  MockGetProfileSettingsLandingScreenUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class MockGetProfileSettingsLandingScreenUseCase: GetProfileSettingsLandingScreenUseCaseProtocol {
    var mockResult: Result<Virgin_Voyages.ProfileSettingsLandingScreenModel, Virgin_Voyages.VVDomainError> = .success(Virgin_Voyages.ProfileSettingsLandingScreenModel(content: ProfileSettingsLandingScreenModel.ContentModel(screenTitle: "", screenDescription: "", imageUrl: ""), menuItems: []))
	
	func execute() async -> Result<Virgin_Voyages.ProfileSettingsLandingScreenModel, Virgin_Voyages.VVDomainError> {
		return mockResult
	}
}

