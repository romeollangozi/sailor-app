//
//  SaveTravelDocumentRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 12.3.25.
//

import Foundation

protocol SaveTravelDocumentRepositoryProtocol {
    func saveTravelDocument(reservationGuestId: String, id: String, embarkDate: String, debarkDate: String, input: SaveTravelDocumentInput) async throws -> SavedTravelDocument?
}

final class SaveTravelDocumentRepository: SaveTravelDocumentRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func saveTravelDocument(reservationGuestId: String, id: String, embarkDate: String, debarkDate: String, input: SaveTravelDocumentInput) async throws -> SavedTravelDocument? {
        guard let response = try await networkService.saveTravelDocument(reservationGuestId: reservationGuestId, embarkDate: embarkDate, debarkDate: debarkDate, id: id, body: input.toNetworkDTO()) else { return nil }
        
		return response.toDomain()
    }
}
