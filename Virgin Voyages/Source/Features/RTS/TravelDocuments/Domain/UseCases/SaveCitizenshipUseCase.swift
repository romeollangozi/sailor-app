//
//  SaveCitizenshipUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 8.9.25.
//

import Foundation

// MARK: - Protocol
protocol SaveCitizenshipUseCaseProtocol {
    func execute(input: CitizenshipModel) async throws -> EmptyResponse
}

// MARK: - Implementation
final class SaveCitizenshipUseCase: SaveCitizenshipUseCaseProtocol {
    private let saveCitizenshipRepository: SaveCitizenshipRepositoryProtocol
    private let currentSailorManager: RtsCurrentSailorProtocol

    init(
        currentSailorManager: RtsCurrentSailorProtocol = RtsCurrentSailorService.shared,
        saveCitizenshipRepository: SaveCitizenshipRepositoryProtocol = SaveCitizenshipRepository()
    ) {
        self.currentSailorManager = currentSailorManager
        self.saveCitizenshipRepository = saveCitizenshipRepository
    }

    func execute(input: CitizenshipModel) async throws -> EmptyResponse {
        let currentSailor = currentSailorManager.getCurrentSailor()
        var model = input
        model.reservationGuestId = currentSailor.reservationGuestId

        try await saveCitizenshipRepository.saveCitizenship(model)

        return EmptyResponse()
        
    }
}
