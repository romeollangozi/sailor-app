//
//  GetDiscoverLandingUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 21.5.25.
//

protocol GetDiscoverLandingUseCaseProtocol {
	func execute(useCache: Bool) async throws -> [DiscoverLandingItem]
}
	
final class GetDiscoverLandingUseCase: GetDiscoverLandingUseCaseProtocol {
	private let discoverLandingRepository: DiscoverLandingRepositoryProtocol
	
	init(discoverLandingRepository: DiscoverLandingRepositoryProtocol = DiscoverLandingRepository()) {
		self.discoverLandingRepository = discoverLandingRepository
	}
	
	func execute(useCache: Bool) async throws -> [DiscoverLandingItem] {
		return try await discoverLandingRepository.fetchDiscoverLandingData(useCache: useCache)
	}
}

