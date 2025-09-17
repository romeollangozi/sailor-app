//
//  DeleteDocumentUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import Foundation

protocol DeleteDocumentUseCaseProtocol {
    func execute(input: DeleteDocumentInput) async throws -> DeletedDocument
}

final class DeleteDocumentUseCase: DeleteDocumentUseCaseProtocol {
    private let deleteDocumentRepository: DeleteDocumentRepositoryProtocol
    private let currentSailorManager: RtsCurrentSailorProtocol

    init(
        currentSailorManager: RtsCurrentSailorProtocol = RtsCurrentSailorService.shared,
        deleteDocumentRepository: DeleteDocumentRepositoryProtocol = DeleteDocumentRepository()
    ) {
        self.currentSailorManager = currentSailorManager
        self.deleteDocumentRepository = deleteDocumentRepository
    }
    
    func execute(input: DeleteDocumentInput) async throws -> DeletedDocument {
        let currentSailor = currentSailorManager.getCurrentSailor()
        
        guard let result = try await deleteDocumentRepository.deleteDocument(
            reservationGuestId: currentSailor.reservationGuestId,
            input: input
        ) else {
            throw VVDomainError.genericError
        }
        
        return result
    }
}
