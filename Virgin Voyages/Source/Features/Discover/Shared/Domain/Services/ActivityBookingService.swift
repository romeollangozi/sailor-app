//
//  ActivityBookingService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 11/18/24.
//

import Foundation

enum ActivityBookingServiceError: Error {
	case invalidPaymentURL
}

enum ActivityBookingServiceResult {
	case success(BookActivityResult)
	case requiresPaymentDetails(paymentURL: URL)
}

protocol ActivityBookingServiceProtocol {
	func processActivityBooking(_ activityBooking: ActivityBooking) async throws -> ActivityBookingServiceResult
}

class ActivityBookingService: ActivityBookingServiceProtocol {
	private var networkService: NetworkServiceProtocol
	private var reservationService: BookingReservationService
    private var bookingEventsNotificationService: BookingEventsNotificationService
    private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol


	init(
		networkService: NetworkServiceProtocol = NetworkService.create(),
		reservationService: BookingReservationService = BookingReservationService(),
        lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository(),
        bookingEventsNotificationService: BookingEventsNotificationService = .shared
	) {
		self.networkService = networkService
		self.reservationService = reservationService
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository

        self.bookingEventsNotificationService = bookingEventsNotificationService
	}

	func processActivityBooking(_ activityBooking: ActivityBooking) async throws -> ActivityBookingServiceResult {
		let reservationDetails = try reservationService.getCurrentReservationDetails()
        let isPreCruise = self.lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation() == .shore
        
		let requestBody = try BookingRequestBuilder()
			.setBooking(activityBooking)
			.setReservationDetails(reservationDetails)
            .setIsPreCruise(isPreCruise)
			.build()

		return try await handleBooking(activityBooking: activityBooking, requestBody: requestBody)
	}

	private func handleBooking(
		activityBooking: ActivityBooking,
		requestBody: BookActivityRequestBody
	) async throws -> ActivityBookingServiceResult {
		if activityBooking.payWithExistingCard {
			let result = try await networkService.bookActivity(requestBody: requestBody)
            print("ActivityBookingService - handleBooking bookActivity result : ", result)
            let bookingResult = bookingResultFromBookingResponse(result)
            let updatedActivityBooking = modifyActivityBookingForNewAppointmentId(activityBooking: activityBooking, updatedId: bookingResult.appointmentId)
            publishApplicationEventOnSuccess(for: updatedActivityBooking)
			return .success(bookingResult)
		} else {
			let result = try await requestPaymentDetails(requestBody: requestBody)
            print("ActivityBookingService - handleBooking requestPaymentDetails result : ", result)
            let updatedActivityBooking = modifyActivityBookingForNewAppointmentId(activityBooking: activityBooking, fromResult: result)
            publishApplicationEventOnSuccess(for: updatedActivityBooking)
            return result
		}
	}

	private func requestPaymentDetails(requestBody: BookActivityRequestBody) async throws -> ActivityBookingServiceResult {
		let result = try await networkService.getBookActivityPaymentPage(requestBody: requestBody)
        
		switch result {
		case .transactionResponse(let transactionResponse):
            return .success(transactionResponse.toDomain())
		case .getBookActivityPaymentPageResponse(let getBookActivityPaymentPageResponse):
			guard let paymentURL = URL(string: getBookActivityPaymentPageResponse.links.form.href) else {
				throw ActivityBookingServiceError.invalidPaymentURL
			}
			return .requiresPaymentDetails(paymentURL: paymentURL)
		}
	}
    
    private func publishApplicationEventOnSuccess(for activity: ActivityBooking) {
		switch activity.operationType{
			case .book:
				bookingEventsNotificationService.publish(.userDidMakeABooking(activityCode: activity.activity.activityCode, activitySlotCode: activity.slot.activitySlotCode))
			case .edit:
                bookingEventsNotificationService.publish(.userDidUpdateABooking(activityCode: activity.activity.activityCode, activitySlotCode: activity.slot.activitySlotCode, appointmentId: activity.appointmentId.value))
			case .cancel:
				bookingEventsNotificationService.publish(.userDidCancelABooking(appointmentLinkId: activity.appointmentLinkId ?? ""))
		}
    }
    
    private func bookingResultFromBookingResponse(_ response: BookActivityResponse) -> BookActivityResult {
        switch response {
        case .transactionResponse(let transactionResponse):
            return transactionResponse.toDomain()
        default: return BookActivityResult.empty()
        }
    }
    
    private func modifyActivityBookingForNewAppointmentId(activityBooking: ActivityBooking, updatedId: String) -> ActivityBooking {
        let activityBookingWithModifiedID = activityBooking
        activityBookingWithModifiedID.appointmentId = updatedId
        return activityBookingWithModifiedID
    }
    
    private func modifyActivityBookingForNewAppointmentId(activityBooking: ActivityBooking, fromResult: ActivityBookingServiceResult) -> ActivityBooking {
        
        switch fromResult {
        case .success(let result):
            return modifyActivityBookingForNewAppointmentId(activityBooking: activityBooking, updatedId: result.appointmentId)
        default: return activityBooking
        }
    }
}
