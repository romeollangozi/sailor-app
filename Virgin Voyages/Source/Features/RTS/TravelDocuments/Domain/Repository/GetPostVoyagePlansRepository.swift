//
//  GetPostVoyagePlansRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import Foundation

protocol GetPostVoyagePlansRepositoryProtocol {
    func getPostVoyagePlans(reservationGuestId: String) async throws -> PostVoyagePlans?
}

final class GetPostVoyagePlansRepository: GetPostVoyagePlansRepositoryProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

    func getPostVoyagePlans(reservationGuestId: String) async throws -> PostVoyagePlans? {
        guard let response = try await networkService.getPostVoyagePlans(reservationGuestId: reservationGuestId) else {
            return nil
        }
        return response.toDomain()
    }
}
