//
//  DiscoverLandingRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 21.5.25.
//

protocol DiscoverLandingRepositoryProtocol {
	func fetchDiscoverLandingData(useCache: Bool) async throws -> [DiscoverLandingItem]
}

final class DiscoverLandingRepository: DiscoverLandingRepositoryProtocol {
	private let networkService: NetworkServiceProtocol

	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}
	
	func fetchDiscoverLandingData(useCache: Bool) async throws -> [DiscoverLandingItem] {
		let response = try await networkService.getDiscoverLanding(cacheOption: .timedCache(cacheExpiry: TimeIntervalDurations.oneWeek, forceReload: !useCache))
		
		return response.map({ $0.toDomain() })
	}
}

