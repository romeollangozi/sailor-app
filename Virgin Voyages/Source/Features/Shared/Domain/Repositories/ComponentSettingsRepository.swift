//
//  ComponentSettingsRepository.swift
//  Virgin Voyages
//
//  Created by Pajtim on 20.5.25.
//

import Foundation

protocol ComponentSettingsRepositoryProtocol {
    func fetchComponentSettings(useCache: Bool) async throws -> [ComponentSettings]
}

final class ComponentSettingsRepository: ComponentSettingsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

    func fetchComponentSettings(useCache: Bool) async throws -> [ComponentSettings] {
		guard let response = try await networkService.getComponentSettings(cacheOption: .timedCache(forceReload: !useCache)) else {
            return []
        }
		
        return response.toDomain()
    }
}

