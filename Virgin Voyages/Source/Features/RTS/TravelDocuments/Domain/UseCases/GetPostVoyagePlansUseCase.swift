//
//  GetPostVoyagePlansUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import Foundation

protocol GetPostVoyagePlansUseCaseProtocol {
    func execute() async throws -> PostVoyagePlans
}

final class GetPostVoyagePlansUseCase: GetPostVoyagePlansUseCaseProtocol {
    private let getPostVoyagePlansRepository: GetPostVoyagePlansRepositoryProtocol
    private let currentSailorManager: RtsCurrentSailorProtocol

    init(
        currentSailorManager: RtsCurrentSailorProtocol = RtsCurrentSailorService.shared,
        getPostVoyagePlansRepository: GetPostVoyagePlansRepositoryProtocol = GetPostVoyagePlansRepository()
    ) {
        self.currentSailorManager = currentSailorManager
        self.getPostVoyagePlansRepository = getPostVoyagePlansRepository
    }

    func execute() async throws -> PostVoyagePlans {
        let currentSailor = currentSailorManager.getCurrentSailor()
        
        guard let response = try await getPostVoyagePlansRepository.getPostVoyagePlans(
            reservationGuestId: currentSailor.reservationGuestId
        ) else {
            throw VVDomainError.genericError
        }
        return response
    }
}
