//
//  MyVoyageRepository.swift
//  Virgin Voyages
//
//  Created by TX on 13.3.25.
//

import Foundation

protocol MyVoyageRepositoryProtocol {
    func fetchMyVoyageStatus(reservationNumber: String, reservationGuestId: String) async throws -> SailingMode?
}

final class MyVoyageRepository: MyVoyageRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchMyVoyageStatus(reservationNumber: String, reservationGuestId: String) async throws -> SailingMode? {
        if let response = try await networkService.getMyVoyageStatus(reservationNumber: reservationNumber, reservationGuestID: reservationGuestId) {
            return response.toDomain()
        } else {
            return nil
        }
    }
}



