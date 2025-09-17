//
//  HelpAndSupportRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.4.25.
//

protocol HelpAndSupportRepositoryProtocol {
	func fetchHelpAndSupport(cacheOption: CacheOption) async throws -> HelpAndSupport?
}

final class HelpAndSupportRepository: HelpAndSupportRepositoryProtocol {
	private let networkService: NetworkServiceProtocol
	
	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}
	
	func fetchHelpAndSupport(cacheOption: CacheOption = .timedCache()) async throws -> HelpAndSupport? {
		let response = try await networkService.fetchHelpAndSupport(cacheOption: cacheOption)
		
		return response?.toDomain()
	}
}


