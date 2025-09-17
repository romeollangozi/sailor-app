//
//  MyVoyageAgendaRepository.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 6.3.25.
//

protocol MyVoyageAgendaRepositoryProtocol {
    func fetchMyVoyageAgenda(shipCode: String, reservationGuestId: String, useCache: Bool) async throws -> MyVoyageAgenda
}

final class MyVoyageAgendaRepository: MyVoyageAgendaRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchMyVoyageAgenda(shipCode: String, reservationGuestId: String, useCache: Bool) async throws -> MyVoyageAgenda {
        let response = try await networkService.getMyVoyageAgenda(shipCode: shipCode, reservationGuestId: reservationGuestId, cacheOption: .timedCache(forceReload: !useCache))
        return response.toDomain()
    }
}
