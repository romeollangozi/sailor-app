//
//  FeatureFlagRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.8.25.
//

import Foundation

protocol FeatureFlagRepositoryProtocol {
	func fetchFeatureFlags(useCache: Bool) async throws -> FeatureFlags?
}

class FeatureFlagRepository: FeatureFlagRepositoryProtocol {
	// MARK: - Properties
	private let netoworkService: NetworkServiceProtocol

	// MARK: - Init
	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.netoworkService = networkService
	}

	// MARK: - Fetch Feature Flags
	func fetchFeatureFlags(useCache: Bool) async throws -> FeatureFlags? {
		guard let response = try await self.netoworkService.getFeatureFlags(cacheOption: useCache ? CacheOption.timedCache(cacheExpiry: TimeIntervalDurations.oneMonth): CacheOption.noCache()) else { return nil }
		
		return response.toDomain()
	}
}
