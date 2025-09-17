//
//  HomePageRepository.swift
//  Virgin Voyages
//
//  Created by TX on 12.3.25.
//

import Foundation

protocol HomePageRepositoryProtocol {
    func fetchHomePageData(reservationNumber: String, reservationGuestId: String, sailingMode: String) async throws -> HomePage?
    func fetchHomePageCheckIn(reservationNumber: String, reservationGuestId: String) async throws -> HomeCheckInSection?
}

class HomePageRepository: HomePageRepositoryProtocol {
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchHomePageData(reservationNumber: String, reservationGuestId: String, sailingMode: String) async throws -> HomePage? {
        if let response = try await networkService.getHomeGeneralContent(reservationNumber: reservationNumber, reservationGuestId: reservationGuestId, sailingMode: sailingMode) {
            return response.toDomain()
        } else {
            return nil
        }
    }
    
    func fetchHomePageCheckIn(reservationNumber: String, reservationGuestId: String) async throws -> HomeCheckInSection? {
        if let response = try await networkService.getHomeCheckIn(reservationNumber: reservationNumber, reservationGuestId: reservationGuestId) {
            return response.toDomain()
        } else {
            return nil
        }
    }
}
