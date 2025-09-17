//
//  GetMyDocumentsRepository.swift
//  Virgin Voyages
//
//  Created by Pajtim on 14.3.25.
//

import Foundation

protocol GetMyDocumentsRepositoryProtocol {
    func getMyDocuments(reservationGuestId: String) async throws -> MyDocuments?
}

final class GetMyDocumentsRepository: GetMyDocumentsRepositoryProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

    func getMyDocuments(reservationGuestId: String) async throws -> MyDocuments? {
        guard let response = try await networkService.getMyDocuments(reservationGuestId: reservationGuestId) else { return nil }
        return response.toDomain()
    }
}
