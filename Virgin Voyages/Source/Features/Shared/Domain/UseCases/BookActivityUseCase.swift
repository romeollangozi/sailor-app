//
//  BookActivityUseCase.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 2/6/25.
//

import Foundation

protocol BookActivityUseCaseProtocol {
	func execute(
		activity: BookableActivity,
		slot: BookableSlot,
		sailorDetails: [BookableSailorDetails],
		operationType: BookingOperationType,
        bookableType: BookableType,
		payWithExistingCard: Bool,
        appointmentId: String?,
		appointmentLinkId: String?
	) async throws -> ActivityBookingServiceResult
	
	func execute(input: BookActivityInputModel) async throws -> ActivityBookingServiceResult
}

final class BookActivityUseCase: BookActivityUseCaseProtocol {
	
	
	let activityBookingService: ActivityBookingServiceProtocol

	init(activityBookingService: ActivityBookingServiceProtocol = ActivityBookingService()) {
		self.activityBookingService = activityBookingService
	}

	func execute(
		activity: BookableActivity,
		slot: BookableSlot,
		sailorDetails: [BookableSailorDetails],
		operationType: BookingOperationType = .book,
        bookableType: BookableType,
		payWithExistingCard: Bool = true,
        appointmentId: String?,
		appointmentLinkId: String?
	) async throws -> ActivityBookingServiceResult {

		let booking = try ActivityBookingBuilder()
			.setActivity(activity)
			.setSlot(slot)
			.setSailors(sailorDetails)
			.setPayWithExistingCard(payWithExistingCard)
			.setOperationType(operationType)
            .setBookableType(bookableType)
            .setAppointmentId(appointmentId)
			.setAppointmentLinkId(appointmentLinkId)
			.build()

		return try await activityBookingService.processActivityBooking(booking)
	}
	
	func execute(input: BookActivityInputModel) async throws -> ActivityBookingServiceResult {
		let booking = try ActivityBookingBuilder()
			.setActivity(input.activity)
			.setSlot(input.slot)
			.setSailors(input.sailorDetails)
			.setPayWithExistingCard(input.payWithExistingCard)
			.setOperationType(input.operationType)
            .setBookableType(input.bookableType)
            .setAppointmentId(input.appointmentId)
			.setAppointmentLinkId(input.appointmentLinkId)
			.build()
		
		return try await activityBookingService.processActivityBooking(booking)
	}
}
