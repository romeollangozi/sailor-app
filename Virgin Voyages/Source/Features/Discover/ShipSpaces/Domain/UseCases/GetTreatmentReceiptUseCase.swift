//
//  GetTreatmentReceiptUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 5.2.25.
//

import Foundation

protocol GetTreatmentReceiptUseCaseProtocol {
    func execute(appointmentId: String) async throws -> TreatmentReceiptModel
}

final class GetTreatmentReceiptUseCase : GetTreatmentReceiptUseCaseProtocol {
    private let treatmentReceiptRepository: GetTreatmentReceiptRepositoryProtocol
	private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(
		treatmentReceiptRepository: GetTreatmentReceiptRepositoryProtocol = GetTreatmentReceiptRepository(),
		lastKnownSailorConnectionLocationRepository : LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository(),
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()
	) {
        self.treatmentReceiptRepository = treatmentReceiptRepository
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
		self.currentSailorManager = currentSailorManager
    }
    

    func execute(appointmentId: String) async throws -> TreatmentReceiptModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let details = try await treatmentReceiptRepository.fetchTreatmentAppointmentDetails(appointmentId: appointmentId, reservationGuestId: currentSailor.reservationGuestId) else {
            throw VVDomainError.genericError
        }
        
        let refundAmount = details.price * Double(details.sailors.count)
        var treatmentReceiptModel = TreatmentReceiptModel.from(details)
        treatmentReceiptModel.cancelConfirmationSubtitle = "\(details.name), \(details.startDateTime.dayAndTimeFormattedString())"
        
        if refundAmount > 0 {
			let sailorLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
            switch sailorLocation {
            case .ship:
				treatmentReceiptModel.refundText = "Refund of \(details.currencyCode.currencySign) \(refundAmount) will be made individually to each sailor as onboard credit"
            case .shore:
				treatmentReceiptModel.refundText = "Refund of \(details.currencyCode.currencySign) \(refundAmount) will be made to the purchasers credit card"
            }
        }
        return treatmentReceiptModel
    }
}
