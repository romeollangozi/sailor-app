//
//  EateriesDetailsRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 30.11.24.
//

protocol EateryDetailsRepositoryProtocol {
    func fetchEateryDetails(slug: String, reservationId: String, reservationGuestId: String, shipCode: String, useCache: Bool) async throws -> EateryDetails?
}

final class EateryDetailsRepository: EateryDetailsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchEateryDetails(slug: String, reservationId: String, reservationGuestId: String, shipCode: String, useCache: Bool) async throws -> EateryDetails? {
        guard let response = try await networkService.getEateriesDetails(slug: slug,
																		 reservationId: reservationId,
																		 reservationGuestId: reservationGuestId,
																		 shipCode: shipCode,
																		 cacheOption: .timedCache(forceReload: !useCache)
		) else { return nil }
        
        return EateryDetails.map(from: response)
    }
}
