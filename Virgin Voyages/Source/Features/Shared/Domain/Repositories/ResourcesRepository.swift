//
//  ResourcesRepository.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 3.5.25.
//

protocol ResourcesRepositoryProtocol {
	func fetchStringResources(useCache: Bool) async throws -> [String: String]
	func fetchAssetResources(useCache: Bool) async throws -> [String: AssetResource]
}

class ResourcesRepository: ResourcesRepositoryProtocol {
	private let networkService: NetworkServiceProtocol
	
	init(networkService: NetworkServiceProtocol = NetworkService.create()) {
		self.networkService = networkService
	}
	
	func fetchStringResources(useCache: Bool) async throws -> [String: String] {
		guard let response = try await networkService.getStringResources(cacheOption: .timedCache(forceReload: !useCache)) else { return [:] }
		
		return response.translations
	}
	
	func fetchAssetResources(useCache: Bool) async throws -> [String : AssetResource] {
		guard let response = try await networkService.getAssetResources(cacheOption: .timedCache(forceReload: !useCache)) else { return [:] }
		
		return response.toDomain()
	}
}
