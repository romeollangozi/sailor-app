//
//  MarkMusterDrillVideoAsWatchedUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 14.4.25.
//

import Foundation

protocol MarkMusterDrillVideoAsWatchedUseCaseProtocol {
    func execute() async throws
}

final class MarkMusterDrillVideoAsWatchedUseCase: MarkMusterDrillVideoAsWatchedUseCaseProtocol {
    private let repository: MusterDrillRepositoryProtocol
    private let currentSailor: CurrentSailorManagerProtocol

    init(
        repository: MusterDrillRepositoryProtocol = MusterDrillRepository(),
        currentSailor: CurrentSailorManagerProtocol = CurrentSailorManager()
    ) {
        self.repository = repository
        self.currentSailor = currentSailor
    }

    func execute() async throws {
		guard let sailor = currentSailor.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        try await repository.markVideoWatched(shipcode: sailor.shipCode, cabinNumber: sailor.cabinNumber ?? "", reservationGuestId: sailor.reservationGuestId)
    }
}
