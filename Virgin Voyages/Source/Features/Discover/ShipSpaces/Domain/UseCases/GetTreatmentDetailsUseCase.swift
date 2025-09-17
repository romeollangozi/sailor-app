//
//  GetTreatmentDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 5.2.25.
//

import Foundation

protocol GetTreatmentDetailsUseCaseProtocol {
    func execute(treatmentId: String) async throws -> TreatmentDetails
}

final class GetTreatmentDetailsUseCase: GetTreatmentDetailsUseCaseProtocol {
    private let treatmentDetailsRepository: GetTreatmentDetailsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol

    init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(), treatmentDetailsRepository: GetTreatmentDetailsRepositoryProtocol = GetTreatmentDetailsRepository()) {
        self.currentSailorManager = currentSailorManager
        self.treatmentDetailsRepository = treatmentDetailsRepository
    }
    
    func execute(treatmentId: String) async throws -> TreatmentDetails {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        guard let response = try await treatmentDetailsRepository.fetchTreatmentDetails(reservationGuestId: currentSailor.reservationGuestId, reservationNumber: currentSailor.reservationNumber, treatmentId: treatmentId) else { throw VVDomainError.genericError }
        return response
    }
}
