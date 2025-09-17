//
//  PayAddOnWithExistingCardUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 10/28/24.
//

import Foundation
import ApptentiveKit

class PayAddOnWithExistingCardUseCase {

	private let addOnPaymentService: AddOnPaymentServiceProtocol
	private let dashboardLandingRepository: DashboardLandingRepositoryProtocol
    private var bookingEventsNotificationService: BookingEventsNotificationService
    private var currentSailorManager: CurrentSailorManagerProtocol

	init(addOnPaymentService: AddOnPaymentServiceProtocol = AddOnPaymentService(),
		 dashboardLandingRepository: DashboardLandingRepositoryProtocol = DashboardLandingMemoryCachingRepository.shared,
         bookingEventsNotificationService: BookingEventsNotificationService = .shared,
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.addOnPaymentService = addOnPaymentService
		self.dashboardLandingRepository = dashboardLandingRepository
        self.bookingEventsNotificationService = bookingEventsNotificationService
        self.currentSailorManager = currentSailorManager
	}

	func execute(reservationNumber: String,
				 guestIds: [String],
				 code: String,
				 quantity: Int,
				 currencyCode: String,
				 amount: String) async throws {
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

		let response = await addOnPaymentService.payAddOnWithExistingCard(reservationNumber: reservationNumber,
																		  guestIds: guestIds,
																		  code: code,
																		  quantity: quantity,
																		  currencyCode: currencyCode,
																		  amount: amount,
																		  guestUniqueId: externalRefId)
		
		if response == .declined {
			throw VVDomainError.genericError
		}

		publishBookingNotification(code: code, activitySlotCode: "")
	}

	private func publishBookingNotification(code: String, activitySlotCode: String) {
		self.bookingEventsNotificationService.publish(.userDidMakeABooking(activityCode: code, activitySlotCode: activitySlotCode))
		Apptentive.shared.engage(event: "addon_booking_complete")
	}
}


extension PayAddOnWithExistingCardUseCase {
    func executeV2(guestIds: [String], code: String, currencyCode: String, amount: Double) async throws -> Bool {
        
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

        let response = await addOnPaymentService.payAddOnWithExistingCard(reservationNumber: currentSailor.reservationNumber,
                                                                          guestIds: guestIds,
                                                                          code: code,
                                                                          quantity: quantity,
                                                                          currencyCode: currencyCode,
                                                                          amount: String(amount),
                                                                          guestUniqueId: externalRefId)
        
        if response == .declined {
            throw VVDomainError.genericError
        }

		publishBookingNotification(code: code, activitySlotCode: "")

        return true
    }

}
