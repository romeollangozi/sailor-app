//
//  SailorProfileV2Repository.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.3.25.
//

import Foundation

protocol SailorProfileV2RepositoryProtocol {
    func getSailorProfile(reservationNumber: String?) async throws -> SailorProfileV2?
}

extension SailorProfileV2RepositoryProtocol {
    func getSailorProfile() async throws -> SailorProfileV2? {
        try await getSailorProfile(reservationNumber: nil)
    }
}

class SailorProfileV2Repository: SailorProfileV2RepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getSailorProfile(reservationNumber: String? = nil) async throws-> SailorProfileV2? {
        guard let response = try await networkService.getSailorsProfile(reservationNumber: reservationNumber) else {
            return nil
        }
        return response.toDomain()
    }
}
