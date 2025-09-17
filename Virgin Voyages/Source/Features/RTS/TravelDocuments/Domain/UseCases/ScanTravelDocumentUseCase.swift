//
//  ScanTravelDocumentUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 4.3.25.
//

import Foundation

protocol ScanTravelDocumentUseCaseProtocol {
    func execute(input: ScanTravelDocumentInputModel) async throws -> TravelDocumentDetails?
}

final class ScanTravelDocumentUseCase: ScanTravelDocumentUseCaseProtocol {
    private let scanTravelDocumentRepository: ScanTravelDocumentRepositoryProtocol
    private let currentSailorManager: RtsCurrentSailorProtocol

    init(
        currentSailorManager: RtsCurrentSailorProtocol = RtsCurrentSailorService.shared,
        scanTravelDocumentRepository: ScanTravelDocumentRepositoryProtocol = ScanTravelDocumentRepository()
    ) {
        self.currentSailorManager = currentSailorManager
        self.scanTravelDocumentRepository = scanTravelDocumentRepository
    }
    
    func execute(input: ScanTravelDocumentInputModel) async throws -> TravelDocumentDetails? {
        let currentSailor = currentSailorManager.getCurrentSailor()
        
        let domainInput = input.toDomain(reservationGuestId: currentSailor.reservationGuestId)

        guard let response = try await scanTravelDocumentRepository.scanTravelDocument(input: domainInput) else {
            throw VVDomainError.genericError
        }
        return response
    }
}
