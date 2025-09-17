//
//  HomePlannerRepository.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 21.3.25.
//

protocol HomePlannerRepositoryProtocol {
    func fetchHomePlanner(reservationGuestId: String, reservationNumber: String, shipCode: String, voyageNumber: String) async throws -> HomePlannerSection?
}

final class HomePlannerRepository: HomePlannerRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchHomePlanner(reservationGuestId: String, reservationNumber: String, shipCode: String, voyageNumber: String) async throws -> HomePlannerSection? {
        guard let response = try await networkService.getHomePlanner(reservationGuestId: reservationGuestId, reservationNumber: reservationNumber, shipCode: shipCode, voyageNumber: voyageNumber) else {
            return nil
        }
        return response.toDomain()
    }
}
