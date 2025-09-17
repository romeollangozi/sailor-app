//
//  SavePostVoyagePlansRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 25.3.25.
//

import Foundation

protocol SavePostVoyagePlansRepositoryProtocol {
    func savePostVoyagePlans(reservationGuestId: String, input: PostVoyagePlansInput) async throws -> EmptyResponse?
}

final class SavePostVoyagePlansRepository: SavePostVoyagePlansRepositoryProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

    func savePostVoyagePlans(reservationGuestId: String, input: PostVoyagePlansInput) async throws -> EmptyResponse?{
        let body = input.toNetworkDTO()
        return try await networkService.savePostVoyagePlans(reservationGuestId: reservationGuestId, body: body)
    }
}
