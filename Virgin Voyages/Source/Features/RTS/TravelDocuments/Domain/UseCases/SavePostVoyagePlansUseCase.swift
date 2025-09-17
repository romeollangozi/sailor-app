//
//  SavePostVoyagePlansUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import Foundation

protocol SavePostVoyagePlansUseCaseProtocol {
    func execute(input: PostVoyagePlansInput) async throws -> EmptyResponse
}

final class SavePostVoyagePlansUseCase: SavePostVoyagePlansUseCaseProtocol {
    private let savePostVoyagePlansRepository: SavePostVoyagePlansRepositoryProtocol
    private let currentSailorManager: RtsCurrentSailorProtocol

    init(
        currentSailorManager: RtsCurrentSailorProtocol = RtsCurrentSailorService.shared,
        savePostVoyagePlansRepository: SavePostVoyagePlansRepositoryProtocol = SavePostVoyagePlansRepository()
    ) {
        self.currentSailorManager = currentSailorManager
        self.savePostVoyagePlansRepository = savePostVoyagePlansRepository
    }

    func execute(input: PostVoyagePlansInput) async throws -> EmptyResponse{
        let currentSailor = currentSailorManager.getCurrentSailor()
        
        guard let response = try await savePostVoyagePlansRepository.savePostVoyagePlans(
            reservationGuestId: currentSailor.reservationGuestId,
            input: input )
        else {
            throw VVDomainError.genericError
        }
        return response
    }
}
