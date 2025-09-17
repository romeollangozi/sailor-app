//
//  FolioRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 14.5.25.
//

import Foundation

protocol FolioRepositoryProtocol {
    func fetchFolio(
		sailingMode: SailingMode,
		reservationGuestId: String,
		reservationId: String
	) async throws -> Folio?
}

final class FolioRepository: FolioRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let resourcesRepository: ResourcesRepositoryProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create(), resourcesRepository: ResourcesRepositoryProtocol = ResourcesRepository()) {
        self.networkService = networkService
        self.resourcesRepository = resourcesRepository
    }

	func fetchFolio(
		sailingMode: SailingMode,
		reservationGuestId: String,
		reservationId: String
	) async throws -> Folio? {
		guard let response = try await networkService.getFolio(
			sailingMode: sailingMode.stringValue,
			reservationGuestId: reservationGuestId,
			reservationId: reservationId
		) else {
            return nil
        }
        return response.toDomain()
    }
}
