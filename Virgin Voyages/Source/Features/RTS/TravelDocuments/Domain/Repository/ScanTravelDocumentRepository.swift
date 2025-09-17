//
//  ScanTravelDocumentRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 4.3.25.
//

import Foundation

protocol ScanTravelDocumentRepositoryProtocol {
    func scanTravelDocument(input: ScanTravelDocumentInput) async throws -> TravelDocumentDetails?
}

final class ScanTravelDocumentRepository: ScanTravelDocumentRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func scanTravelDocument(input: ScanTravelDocumentInput) async throws -> TravelDocumentDetails? {
        let inputBody = input.toNetworkDTO()
        guard let response = try await networkService.scanTravelDocument(reservationGuestId: input.reservationGuestId, id: input.id, ocrValidation: input.ocrValidation, body: inputBody) else { return nil }
        return response.toDomain()
    }
}
