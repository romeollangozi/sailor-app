//
//  GetTreatmentDetailsRepository.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 5.2.25.
//

import Foundation

protocol GetTreatmentDetailsRepositoryProtocol {
    func fetchTreatmentDetails(reservationGuestId: String, reservationNumber: String, treatmentId: String) async throws -> TreatmentDetails?
}

final class GetTreatmentDetailsRepository: GetTreatmentDetailsRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func fetchTreatmentDetails(reservationGuestId: String, reservationNumber: String, treatmentId: String) async throws -> TreatmentDetails? {
        guard let response = try await networkService.getTreatmentDetails(reservationGuestId: reservationGuestId, reservationNumber: reservationNumber, treatmentId: treatmentId) else { return nil }
        return TreatmentDetails.map(from: response)
    }
}
