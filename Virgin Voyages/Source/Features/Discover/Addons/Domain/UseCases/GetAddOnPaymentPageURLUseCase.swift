//
//  GetAddOnPaymentPageURLUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/23/24.
//

import Foundation

enum GetAddOnPaymentPageURLUseCaseResult {
	case paymentRequired(URL)
	case paymentNotRequired
}

class GetAddOnPaymentPageURLUseCase {

	private let addOnPaymentService: AddOnPaymentServiceProtocol
	private let dashboardLandingRepository: DashboardLandingRepositoryProtocol
    private var currentSailorManager: CurrentSailorManagerProtocol

    
	init(addOnPaymentService: AddOnPaymentServiceProtocol = AddOnPaymentService(),
		 dashboardLandingRepository: DashboardLandingRepositoryProtocol = DashboardLandingMemoryCachingRepository.shared,
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {

		self.addOnPaymentService = addOnPaymentService
		self.dashboardLandingRepository = dashboardLandingRepository
        self.currentSailorManager = currentSailorManager
	}

	func execute(reservationNumber: String,
				 guestIds: [String],
				 code: String,
				 quantity: Int,
				 currencyCode: String,
				 amount: String) async throws -> GetAddOnPaymentPageURLUseCaseResult {
		guard let reservationGuestID = try? AuthenticationService.shared.currentSailor().reservation.reservationGuestId else {
			throw VVDomainError.genericError
		}

		guard let dashboardLanding = await dashboardLandingRepository.fetchDashboardLanding(reservationNumber: reservationNumber,
																							guestId: reservationGuestID) else {
			throw VVDomainError.genericError
		}

		guard let externalRefId = dashboardLanding.externalRefId else {
			throw VVDomainError.genericError
		}

		let addOnPaymentResponse = await addOnPaymentService.fetchPaymentURL(reservationNumber: reservationNumber,
																   guestIds: guestIds,
																   code: code,
																   quantity: quantity,
																   currencyCode: currencyCode,
																   amount: amount,
																   guestUniqueId: externalRefId)

		if case .success(let paymentURL) = addOnPaymentResponse {
			return .paymentRequired(paymentURL)
		}
		if case .noPaymentRequired = addOnPaymentResponse {
			return .paymentNotRequired
		}
		if case .failure = addOnPaymentResponse {
			throw VVDomainError.genericError
		}

		return .paymentNotRequired
	}
}


extension GetAddOnPaymentPageURLUseCase {
    func executeV2(guestIds: [String], code: String, currencyCode: String, amount: Double) async throws -> GetAddOnPaymentPageURLUseCaseResult {

		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        guard let dashboardLanding = await dashboardLandingRepository.fetchDashboardLanding(
            reservationNumber: currentSailor.reservationNumber,
            guestId: currentSailor.reservationGuestId) else {
            
            throw VVDomainError.genericError
        }

        guard let externalRefId = dashboardLanding.externalRefId else {
            throw VVDomainError.genericError
        }
        
        let quantity = 1 // Always 1 for now
        
        let addOnPaymentResponse = await addOnPaymentService.fetchPaymentURL(reservationNumber: currentSailor.reservationNumber,
                                                                   guestIds: guestIds,
                                                                   code: code,
                                                                   quantity: quantity,
                                                                   currencyCode: currencyCode,
                                                                   amount: String(amount),
                                                                   guestUniqueId: externalRefId)
        
		if case .success(let paymentURL) = addOnPaymentResponse {
			return .paymentRequired(paymentURL)
		}
		if case .noPaymentRequired = addOnPaymentResponse {
			return .paymentNotRequired
		}
		if case .failure = addOnPaymentResponse {
			throw VVDomainError.genericError
		}

		return .paymentNotRequired
    }

}
