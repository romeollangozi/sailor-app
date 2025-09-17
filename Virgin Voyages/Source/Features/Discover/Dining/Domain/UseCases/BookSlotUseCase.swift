//
//  BookSlotUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 27.11.24.
//

protocol BookSlotUseCaseProtocol {
    func execute(input: BookSlotInputModel) async throws -> BookSlot
}

final class BookSlotUseCase: BookSlotUseCaseProtocol {
    private let bookSlotRepository: BookSlotRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
	private var bookingEventsNotificationService: BookingEventsNotificationService
	
    init(bookSlotRepository: BookSlotRepositoryProtocol = BookSlotRepository(),
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 bookingEventsNotificationService: BookingEventsNotificationService = BookingEventsNotificationService.shared
	) {
        self.bookSlotRepository = bookSlotRepository
        self.currentSailorManager = currentSailorManager
		self.bookingEventsNotificationService = bookingEventsNotificationService
    }
    
    func execute(input: BookSlotInputModel) async throws -> BookSlot {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

        let request = BookSlotInput(isPayWithSavedCard: false,
                                    loggedInReservationGuestId: currentSailor.reservationGuestId,
                                    reservationNumber: currentSailor.reservationNumber,
                                    isGift: false,
                                    accessories: [],
                                    currencyCode: "USD",
                                    operationType: nil,
                                    categoryCode: "RT",
                                    voyageNumber: currentSailor.voyageNumber,
                                    extraGuestCount: 0,
                                    personDetails: input.personDetails.map({
            guest in .init(personId: guest.personId,
                           reservationNumber: guest.reservationNumber,
                           guestId: guest.guestId)
        }),
                                    activityCode: input.activityCode,
                                    shipCode: currentSailor.shipCode,
                                    activitySlotCode: input.activitySlotCode,
                                    startDate: input.startDate.toISO8601())
        
        guard let response = try await bookSlotRepository.bookSlot(input: request)  else { throw VVDomainError.genericError }
		
		bookingEventsNotificationService.publish(.userDidMakeABooking(activityCode: input.activityCode, activitySlotCode: input.activitySlotCode))
        
        return response
    }
}
