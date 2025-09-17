//
//  ComponentSettingsUseCase.swift
//  Virgin Voyages
//
//  Created by Pajtim on 20.5.25.
//

import Foundation

protocol ComponentSettingsUseCaseProtocol {
	func execute(useCache: Bool) async throws -> [ComponentSettings]?
}

final class ComponentSettingsUseCase: ComponentSettingsUseCaseProtocol {
    private let repository: ComponentSettingsRepositoryProtocol

    init(repository: ComponentSettingsRepositoryProtocol = ComponentSettingsRepository()) {
        self.repository = repository
    }

    func execute(useCache: Bool) async throws -> [ComponentSettings]? {
		return try await repository.fetchComponentSettings(useCache: useCache)
    }
}
