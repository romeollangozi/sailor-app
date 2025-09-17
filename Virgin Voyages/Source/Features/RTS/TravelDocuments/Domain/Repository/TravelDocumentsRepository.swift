//
//  TravelDocumentsRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 18.2.25.
//

import Foundation

protocol TravelDocumentsRepositoryProtocol {
    func fetchTravelDocuments(reservationGuestId: String) async throws -> TravelDocuments?
}

final class TravelDocumentsRepository: TravelDocumentsRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchTravelDocuments(reservationGuestId: String) async throws -> TravelDocuments? {
        guard let response = try await networkService.getTravelDocuments(reservationGuestId: reservationGuestId) else { return nil }
        return response.toDomain()
    }
}
