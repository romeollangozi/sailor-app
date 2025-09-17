//
//  GetTravelDocumentsUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 18.2.25.
//

import Foundation

protocol GetTravelDocumentsUseCaseProtocol {
    func execute() async throws -> TravelDocuments
}

final class GetTravelDocumentsUseCase: GetTravelDocumentsUseCaseProtocol {
    private let travelDocumentsRepository: TravelDocumentsRepositoryProtocol
    private let currentSailorManager: RtsCurrentSailorProtocol

    init(
        currentSailorManager: RtsCurrentSailorProtocol = RtsCurrentSailorService.shared,
        travelDocumentsRepository: TravelDocumentsRepositoryProtocol = TravelDocumentsRepository()
    ) {
        self.currentSailorManager = currentSailorManager
        self.travelDocumentsRepository = travelDocumentsRepository
    }
    
    func execute() async throws -> TravelDocuments {
        let currentSailor = currentSailorManager.getCurrentSailor()
        
        guard let response = try await travelDocumentsRepository.fetchTravelDocuments(reservationGuestId: currentSailor.reservationGuestId) else {
            throw VVDomainError.genericError
        }
        return response
    }
}
