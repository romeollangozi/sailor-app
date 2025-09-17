//
//  CancelBookingSlotUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 11.12.24.
//

protocol CancelBookingSlotUseCaseProtocol {
    func execute(input: CancelBookingSlotInputModel) async throws -> CancelBookingSlotModel
}

final class CancelBookingSlotUseCase: CancelBookingSlotUseCaseProtocol {
    private let updateBookingSlotRepository: UpdateBookingSlotRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
	private var bookingEventsNotificationService: BookingEventsNotificationService
	
    init(updateBookingSlotRepository: UpdateBookingSlotRepositoryProtocol = UpdateBookingSlotRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 bookingEventsNotificationService: BookingEventsNotificationService = BookingEventsNotificationService.shared
	) {
        self.updateBookingSlotRepository = updateBookingSlotRepository
        self.currentSailorManager = currentSailorManager
		self.bookingEventsNotificationService = bookingEventsNotificationService
    }
    
    func execute(input: CancelBookingSlotInputModel) async throws -> CancelBookingSlotModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		let guests : [UpdateBookingSlotInput.PersonDetail] = input.guests == 1
		? [UpdateBookingSlotInput.PersonDetail(personId: currentSailor.reservationGuestId, reservationNumber: currentSailor.reservationNumber, guestId: currentSailor.guestId, status: EditBookingSailorStatus.cancelled.rawValue)]
        : input.personDetails.map({
            guest in UpdateBookingSlotInput.PersonDetail(personId: guest.personId,
                                                         reservationNumber: guest.reservationNumber,
                                                         guestId: guest.guestId,
														 status: EditBookingSailorStatus.cancelled.rawValue)
        })
        
        let request = UpdateBookingSlotInput(isPayWithSavedCard: false,
                                             loggedInReservationGuestId: currentSailor.reservationGuestId,
                                             reservationNumber: currentSailor.reservationNumber,
                                             isGift: false,
                                             accessories: [],
                                             currencyCode: "USD",
                                             operationType: "CANCEL",
                                             categoryCode: "RT",
                                             voyageNumber: currentSailor.voyageNumber,
                                             extraGuestCount: 0,
                                             personDetails: guests,
                                             activityCode: input.activityCode,
                                             shipCode: currentSailor.shipCode,
                                             activitySlotCode: input.activitySlotCode,
                                             startDate: input.startDate.toISO8601(),
                                             appointmentLinkId: input.appointmentLinkId,
                                             isSwapped: false)
        
        guard let response = try await updateBookingSlotRepository.updateBookingSlot(input: request)  else { throw VVDomainError.genericError }
		
		bookingEventsNotificationService.publish(.userDidCancelABooking(appointmentLinkId: input.appointmentLinkId))
		
        return CancelBookingSlotModel.map(from: response)
    }
}
