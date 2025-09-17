//
//  GetLookupRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 13.3.25.
//

import Foundation

protocol GetLookupRepositoryProtocol {
	func fetchLookupData(useCache: Bool) async throws -> Lookup?
}

final class GetLookupRepository: GetLookupRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchLookupData(useCache: Bool) async throws -> Lookup? {
		let response = try await networkService.getLookupData(cacheOption: .timedCache(forceReload: !useCache))
		
        return response?.toDomain()
    }
}
