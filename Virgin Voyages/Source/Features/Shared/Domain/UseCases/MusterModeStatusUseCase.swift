//
//  MusterModeStatusUseCase.swift
//  Virgin Voyages
//
//  Created by Pajtim on 25.8.25.
//

import Foundation

protocol MusterModeStatusUseCaseProtocol {
    func getMusterMode() -> MusterDrillContent.MusterDrillMode
    func updateMusterMode(_ mode: MusterDrillContent.MusterDrillMode) throws
}

// MARK: - Implementations
struct MusterModeStatusUseCase: MusterModeStatusUseCaseProtocol {
    private let repository: MusterModeStatusRepositoryProtocol

    init(repository: MusterModeStatusRepositoryProtocol = MusterModeStatusRepository()) {
        self.repository = repository
    }

    func getMusterMode() -> MusterDrillContent.MusterDrillMode {
        return repository.fetchMusterMode()
    }

    func updateMusterMode(_ mode: MusterDrillContent.MusterDrillMode) throws {
        try repository.updateMusterMode(mode)
    }
}
