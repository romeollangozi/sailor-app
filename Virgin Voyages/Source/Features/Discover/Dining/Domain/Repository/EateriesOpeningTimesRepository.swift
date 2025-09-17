//
//  EateriesOpeningTimesRepository.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 3.12.24.
//

protocol EateriesOpeningTimesRepositoryProtocol {
    func fetchEateriesOpeningTimes(reservationId: String,
                           reservationGuestId: String,
                           shipCode: String,
                           reservationNumber: String,
                           selectedDate: String) async throws -> EateriesOpeningTimes?
}

final class EateriesOpeningTimesRepository: EateriesOpeningTimesRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchEateriesOpeningTimes(reservationId: String,
                            reservationGuestId: String,
                            shipCode: String,
                            reservationNumber: String,
                            selectedDate: String) async throws -> EateriesOpeningTimes? {
        guard let response = try await networkService.getEateriesOpeningTimes(reservationId: reservationId,
                                                                              reservationGuestId: reservationGuestId,
                                                                              shipCode: shipCode,
                                                                              reservationNumber: reservationNumber,
                                                                              selectedDate: selectedDate) else { return nil }
        
        return EateriesOpeningTimes.map(from: response)
    }
}
