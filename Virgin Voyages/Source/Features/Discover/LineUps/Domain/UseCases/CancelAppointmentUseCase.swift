//
//  CancelAppointmentUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 3.2.25.
//

import Foundation

protocol CancelAppointmentUseCaseProtocol {
    func execute(inputModel: CancelAppointmentInputModel) async throws -> CancelAppointment
}

final class CancelAppointmentUseCase: CancelAppointmentUseCaseProtocol {
    
    private let cancelAppointmentRepository: CancelAppointmentRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    private var bookingEventsNotificationService: BookingEventsNotificationService
    
    init(cancelAppointmentRepository: CancelAppointmentRepositoryProtocol = CancelAppointmentRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
         bookingEventsNotificationService: BookingEventsNotificationService = .shared) {
        self.cancelAppointmentRepository = cancelAppointmentRepository
        self.currentSailorManager = currentSailorManager
        self.bookingEventsNotificationService = bookingEventsNotificationService
    }
    
    func execute(inputModel: CancelAppointmentInputModel) async throws -> CancelAppointment {
        
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}
		
        let currentSailorPerson = CancelAppointmentInput.PersonDetail(personId: currentSailor.reservationGuestId, guestId: currentSailor.guestId, reservationNumber: currentSailor.reservationNumber)
        
		let guests = (inputModel.numberOfGuests > 1) ? inputModel.personDetails.toDTO() : [currentSailorPerson]

        let input = CancelAppointmentInput(appointmentLinkId: inputModel.appointmentLinkId,
                                           isRefund: inputModel.isRefund,
                                           loggedInReservationGuestId: currentSailor.reservationGuestId,
                                           reservationNumber: currentSailor.reservationNumber,
                                           categoryCode: inputModel.categoryCode,
                                           personDetails: guests
        )
        
        let result = try await cancelAppointmentRepository.cancelAppointment(input: input)
		bookingEventsNotificationService.publish(.userDidCancelABooking(appointmentLinkId: inputModel.appointmentLinkId))
        return result
    }
}
