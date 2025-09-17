//
//  UpdateBookingSlotUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 5.12.24.
//

protocol UpdateBookingSlotUseCaseProtocol {
    func execute(input: UpdateBookingSlotInputModel) async throws -> UpdateBookingSlotModel
}

final class UpdateBookingSlotUseCase: UpdateBookingSlotUseCaseProtocol {
    private let updateBookingSlotRepository: UpdateBookingSlotRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
	private var bookingEventsNotificationService: BookingEventsNotificationService
	
    init(updateBookingSlotRepository: UpdateBookingSlotRepositoryProtocol = UpdateBookingSlotRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 sailorsRepository: SailorsRepositoryProtocol = SailorsRepository(),
		 bookingEventsNotificationService: BookingEventsNotificationService = BookingEventsNotificationService()
	) {
        self.updateBookingSlotRepository = updateBookingSlotRepository
        self.currentSailorManager = currentSailorManager
		self.bookingEventsNotificationService = bookingEventsNotificationService
    }
    
    func execute(input: UpdateBookingSlotInputModel) async throws -> UpdateBookingSlotModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		let inputSailors = try await createSailorsInput(input: input, currentSailor: currentSailor)
		
        let request = UpdateBookingSlotInput(isPayWithSavedCard: false,
                                             loggedInReservationGuestId: currentSailor.reservationGuestId,
                                             reservationNumber: currentSailor.reservationNumber,
                                             isGift: false,
                                             accessories: [],
                                             currencyCode: "USD",
                                             operationType: "EDIT",
                                             categoryCode: "RT",
                                             voyageNumber: currentSailor.voyageNumber,
                                             extraGuestCount: 0,
											 personDetails: inputSailors,
                                             activityCode: input.activityCode,
                                             shipCode: currentSailor.shipCode,
                                             activitySlotCode: input.activitySlotCode,
                                             startDate: input.startDate.toISO8601(),
                                             appointmentLinkId: input.appointmentLinkId,
                                             isSwapped: false)
        
        guard let response = try await updateBookingSlotRepository.updateBookingSlot(input: request)  else { throw VVDomainError.genericError }
		
        bookingEventsNotificationService.publish(.userDidUpdateABooking(activityCode: input.activityCode, activitySlotCode: input.activitySlotCode, appointmentId: (response.appointment?.appointmentId).value))

        return UpdateBookingSlotModel.map(from: response)
    }
	
	private func createSailorsInput(input: UpdateBookingSlotInputModel, currentSailor: CurrentSailor) async throws -> [UpdateBookingSlotInput.PersonDetail] {
		
		let sailorsWithEditBookingStatus = EditBookingSailorStatusCalculator.caclulate(previousBookedSailors: input.previousBookedSailors,
																					   newBookedSailors: input.sailors)
		
		var sailorsInput: [UpdateBookingSlotInput.PersonDetail] = []
		for (_, sailor) in sailorsWithEditBookingStatus.enumerated() {
			let status = sailor.value.rawValue.isEmpty ? nil : sailor.value.rawValue
			sailorsInput.append(.init(personId: sailor.key.reservationGuestId, reservationNumber: sailor.key.reservationNumber, guestId: sailor.key.guestId, status: status))
		}
		
		return sailorsInput
	}
}
