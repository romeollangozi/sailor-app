//
//  GetLineUpAppointmentDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 22.1.25.
//

protocol GetLineUpAppointmentDetailsUseCaseProtocol {
    func execute(appointmentId: String) async throws -> LineUpReceiptModel
}

final class GetLineUpAppointmentDetailsUseCase : GetLineUpAppointmentDetailsUseCaseProtocol {
    private let lineUpRepository: LineUpRepositoryProtocol
	private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol

    init(lineUpRepository: LineUpRepositoryProtocol = LineUpRepository(),
		 lastKnownSailorConnectionLocationRepository : LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository(),
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.lineUpRepository = lineUpRepository
		self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
		self.currentSailorManager = currentSailorManager
    }
    
    func execute(appointmentId: String) async throws -> LineUpReceiptModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let details = try await lineUpRepository.fetchLineUpAppointmentDetails(appointmentId: appointmentId, reservationGuestId: currentSailor.reservationGuestId) else {
            throw VVDomainError.genericError
        }

		var lineUpReceiptModel = LineUpReceiptModel.map(from: details)
		let refundAmount = details.price

		if refundAmount > 0 {
			let sailorLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
			switch sailorLocation {
			case .ship:
				lineUpReceiptModel.refundTextForIndividual = "Refund of \(details.currencyCode.currencySign)\(refundAmount) will be made to you as onboard credit"
				lineUpReceiptModel.refundTextForGroup = "Refund of \(details.currencyCode.currencySign)\(refundAmount * Double(details.sailors.count)) will be made individually to each sailor as onboard credit"
			case .shore:
				lineUpReceiptModel.refundTextForIndividual = "Refund of  \(details.currencyCode.currencySign)\(refundAmount) will be made to the purchasers credit card"
				lineUpReceiptModel.refundTextForGroup = "Refund of \(details.currencyCode.currencySign)\(refundAmount * Double(details.sailors.count)) will be made to the purchasers credit card"
			}
		}
        return lineUpReceiptModel
    }
}
