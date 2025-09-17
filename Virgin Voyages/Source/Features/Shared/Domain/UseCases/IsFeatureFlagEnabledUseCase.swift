//
//  IsFeatureFlagEnabledUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.8.25.
//

import Foundation

protocol IsFeatureFlagEnabledUseCaseProtocol {
	func execute(feature: String) async throws -> Bool
}

class IsFeatureFlagEnabledUseCase: IsFeatureFlagEnabledUseCaseProtocol {
	private let featureFlagRepository: FeatureFlagRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	
	init(featureFlagRepository: FeatureFlagRepositoryProtocol = FeatureFlagRepository(),
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.featureFlagRepository = featureFlagRepository
		self.currentSailorManager = currentSailorManager
	}
	
	func execute(feature: String) async throws -> Bool {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
		guard let result = try? await featureFlagRepository.fetchFeatureFlags(useCache: true) else {
			return false
		}
		
		return result.isFeatureEnabled(for: feature, reservationGuestId: currentSailor.reservationGuestId, shipCode: currentSailor.shipCode)
	}
}
