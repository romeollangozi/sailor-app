//
//  ReservationsRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 14.11.24.
//

protocol ReservationsRepositoryProtocol {
    func fetchSailorReservations() async throws -> SailorReservations?
    func fetchSailorReservationSummary(reservationNumber: String) async throws -> SailorReservationSummary?
}

class ReservationsRepository: ReservationsRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchSailorReservations() async throws -> SailorReservations? {
        guard let response = try await networkService.getSailorReservations() else { return nil }
        
        return SailorReservations.map(from: response)
    }
    
    func fetchSailorReservationSummary(reservationNumber: String) async throws -> SailorReservationSummary? {
        guard let response = try await networkService.getSailorReservationSummary(reservationNumber: reservationNumber) else { return nil }
        
        return SailorReservationSummary.map(from: response)
    }
}
