//
//  HomeComingGuideRepository.swift
//  Virgin Voyages
//
//  Created by Pajtim on 2.4.25.
//

import Foundation

protocol HomeComingGuideRepositoryProtocol {
    func getHomeComingGuide(reservationGuestId: String, reservationId: String, debarkDate: String, shipCode: String, voyageNumber: String) async throws -> HomeComingGuide?
}

final class HomeComingGuideRepository: HomeComingGuideRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

    func getHomeComingGuide(reservationGuestId: String, reservationId: String, debarkDate: String, shipCode: String, voyageNumber: String) async throws -> HomeComingGuide? {
		guard let response = try await networkService.getHomeComingGuide(reservationGuestId: reservationGuestId, reservationId: reservationId, debarkDate: debarkDate, shipCode: shipCode, voyageNumber: voyageNumber) else {
            return nil
        }
        return response.toDomain()
    }
}
