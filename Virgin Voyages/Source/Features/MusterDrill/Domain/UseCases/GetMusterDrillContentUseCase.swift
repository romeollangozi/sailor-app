//
//  GetMusterDrillContentUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 7.4.25.
//

import Foundation

protocol GetMusterDrillContentUseCaseProtocol {
    func execute() async throws -> MusterDrillContent
}

final class GetMusterDrillContentUseCase: GetMusterDrillContentUseCaseProtocol {
    private let repository: MusterDrillRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    private let musterModeStatusUseCase: MusterModeStatusUseCaseProtocol

    init(
        repository: MusterDrillRepositoryProtocol = MusterDrillRepository(),
        currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
        musterModeStatusUseCase: MusterModeStatusUseCaseProtocol = MusterModeStatusUseCase()
    ) {
        self.repository = repository
        self.currentSailorManager = currentSailorManager
        self.musterModeStatusUseCase = musterModeStatusUseCase
    }

    func execute() async throws -> MusterDrillContent {
		guard let sailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        if let result = try await repository.fetchMusterDrillContent(shipcode: sailor.shipCode, guestId: sailor.reservationGuestId) {
            try musterModeStatusUseCase.updateMusterMode(result.mode)
            return result
        } else {
            throw VVDomainError.notFound
        }
    }
}
