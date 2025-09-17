//
//  GetMyDocumentsUseCase.swift
//  Virgin Voyages
//
//  Created by Pajtim on 14.3.25.
//

import Foundation

protocol GetMyDocumentsUseCaseProtocol {
    func execute() async throws -> MyDocuments
}

final class GetMyDocumentsUseCase: GetMyDocumentsUseCaseProtocol {
    private let getMyDocumentsRepository: GetMyDocumentsRepositoryProtocol
    private let currentSailorManager: RtsCurrentSailorProtocol

    init(
        currentSailorManager: RtsCurrentSailorProtocol = RtsCurrentSailorService.shared,
        getMyDocumentsRepository: GetMyDocumentsRepositoryProtocol = GetMyDocumentsRepository()
    ) {
        self.currentSailorManager = currentSailorManager
        self.getMyDocumentsRepository = getMyDocumentsRepository
    }

    func execute() async throws -> MyDocuments {
        let currentSailor = currentSailorManager.getCurrentSailor()
        
        guard let response = try await getMyDocumentsRepository.getMyDocuments(reservationGuestId: currentSailor.reservationGuestId) else {
            throw VVDomainError.genericError
        }
        return response
    }
}
