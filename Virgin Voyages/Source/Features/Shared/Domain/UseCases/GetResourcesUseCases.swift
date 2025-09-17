//
//  GetResourcesUseCases.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.5.25.
//

protocol GetResourcesUseCaseProtocol {
	func getStringResources(useCache: Bool) async throws -> [String: String]
	func getAssetResources(useCache: Bool) async throws -> [String: AssetResource]
}

final class GetResourcesUseCase: GetResourcesUseCaseProtocol {
	private let resourcesRepository: ResourcesRepositoryProtocol
	
	init(resourcesRepository: ResourcesRepositoryProtocol = ResourcesRepository()) {
		self.resourcesRepository = resourcesRepository
	}
	
	func getStringResources(useCache: Bool) async throws -> [String : String] {
		return try await resourcesRepository.fetchStringResources(useCache: useCache)
	}
	
	func getAssetResources(useCache: Bool) async throws -> [String : AssetResource] {
		return try await resourcesRepository.fetchAssetResources(useCache: useCache)
	}

}

