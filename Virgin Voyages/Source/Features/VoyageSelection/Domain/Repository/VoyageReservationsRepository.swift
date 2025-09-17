//
//  VoyageReservationsRepository.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 1.6.25.
//

protocol VoyageReservationsRepositoryProtocol {
    func fetchVoyageReservations() async throws -> VoyageReservations?
}

final class VoyageReservationsRepository: VoyageReservationsRepositoryProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

    func fetchVoyageReservations() async throws -> VoyageReservations? {
        guard let response = try await networkService.getVoyageReservations() else {
            return nil
        }
        return response.toDomain()
    }
}
