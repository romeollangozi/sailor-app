//
//  DeleteDocumentRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 21.3.25.
//

import Foundation

protocol DeleteDocumentRepositoryProtocol {
    func deleteDocument(reservationGuestId: String, input: DeleteDocumentInput) async throws -> DeletedDocument?
}

final class DeleteDocumentRepository: DeleteDocumentRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func deleteDocument(reservationGuestId: String, input: DeleteDocumentInput) async throws -> DeletedDocument? {
        let body = input.toNetworkDTO()

        guard let response = try await networkService.deleteTravelDocument(reservationGuestId: reservationGuestId, body: body) else { return nil }
        
        return response.toDomain()
    }
}
