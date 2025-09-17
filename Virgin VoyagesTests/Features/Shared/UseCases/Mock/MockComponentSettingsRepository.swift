//
//  MockComponentSettingsRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 23.5.25.
//

@testable import Virgin_Voyages

final class MockComponentSettingsRepository: ComponentSettingsRepositoryProtocol {
	var mockResponse = [Virgin_Voyages.ComponentSettings]()
		
	func fetchComponentSettings(useCache: Bool) async throws -> [Virgin_Voyages.ComponentSettings] {
		return mockResponse
	}
}

