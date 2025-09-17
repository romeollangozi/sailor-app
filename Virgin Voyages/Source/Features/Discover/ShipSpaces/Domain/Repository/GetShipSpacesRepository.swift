//
//  GetShipSpacesCategoriesRepositoryProtocol.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 29.1.25.
//

import Foundation

protocol GetShipSpacesCategoriesRepositoryProtocol {
    func fetchShipSpaces(reservationId: String, guestId: String, shipCode: String, useCache: Bool) async throws -> ShipSpacesCategories?
}

final class GetShipSpacesRepository: GetShipSpacesCategoriesRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchShipSpaces(reservationId: String, guestId: String, shipCode: String, useCache: Bool = false) async throws -> ShipSpacesCategories? {
        guard let response = try await networkService.getShipSpaces(reservationId: reservationId, guestId: guestId, shipCode: shipCode, cacheOption: .timedCache(forceReload: !useCache)) else { return nil }
        return ShipSpacesCategories.map(from: response)
    }

}
