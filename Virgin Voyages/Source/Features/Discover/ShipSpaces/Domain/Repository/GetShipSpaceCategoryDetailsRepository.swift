//
//  GetShipSpaceCategoryRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 30.1.25.
//

import Foundation

protocol GetShipSpaceCategoryDetailsRepositoryProtocol {
    func fetchShipSpaceCategoryDetails(shipSpaceCategoryCode: String, guestId: String, shipCode: String, useCache: Bool) async throws -> ShipSpaceCategoryDetails?
}

final class GetShipSpaceCategoryRepository: GetShipSpaceCategoryDetailsRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
        
    }
    
    func fetchShipSpaceCategoryDetails(shipSpaceCategoryCode: String, guestId: String, shipCode: String, useCache: Bool = false) async throws -> ShipSpaceCategoryDetails? {
        guard let response = try await networkService.getShipSpaceCategoryDetails(shipSpaceCategoryCode: shipSpaceCategoryCode, guestId: guestId, shipCode: shipCode, cacheOption: .timedCache(forceReload: !useCache)) else { return nil }
        return ShipSpaceCategoryDetails.map(from: response)
    }
}
