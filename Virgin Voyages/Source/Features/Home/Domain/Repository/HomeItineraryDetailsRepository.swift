//
//  HomeItineraryDetailsRepository.swift
//  Virgin Voyages
//
//  Created by Pajtim on 7.4.25.
//

import Foundation

protocol HomeItineraryDetailsRepositoryProtocol {
    func getItineraryDetails(reservationGuestId: String, voyageNumber: String, reservationNumber: String) async throws -> HomeItineraryDetails?
}

final class HomeItineraryDetailsRepository: HomeItineraryDetailsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }

    func getItineraryDetails(reservationGuestId: String, voyageNumber: String, reservationNumber: String) async throws -> HomeItineraryDetails? {
        guard let response = try await networkService.getItineraryDetails(reservationGuestId: reservationGuestId, voyageNumber: voyageNumber, reservationNumber: reservationNumber) else {
            return nil
        }
        return response.toDomain()
    }
}
