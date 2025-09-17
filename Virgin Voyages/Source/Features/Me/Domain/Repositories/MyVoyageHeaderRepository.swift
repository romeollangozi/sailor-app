//
//  MyVoyageHeaderRepository.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 26.2.25.
//

protocol MyVoyageHeaderRepositoryProtocol {
    func fetchMyVoyageHeader(reservationGuestId: String, reservationNumber: String, useCache: Bool) async throws -> MyVoyageHeader
}

final class MyVoyageHeaderRepository: MyVoyageHeaderRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchMyVoyageHeader(reservationGuestId: String, reservationNumber: String, useCache: Bool) async throws -> MyVoyageHeader {
		let response = try await networkService.getMyVoyageHeader(reservationGuestId: reservationGuestId, reservationNumber: reservationNumber, cacheOption: .timedCache(forceReload: !useCache))
        
        return response.toDomain()
    }
}
