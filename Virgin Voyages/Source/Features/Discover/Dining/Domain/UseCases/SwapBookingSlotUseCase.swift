//
//  SwapBookingSlotUseCase.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 28.11.24.
//

protocol SwapBookingSlotUseCaseProtocol {
    func execute(input: SwapBookingSlotInputModel) async throws -> SwapBookingSlotModel
}

final class SwapBookingSlotUseCase: SwapBookingSlotUseCaseProtocol {
    private let updateBookingSlotRepository: UpdateBookingSlotRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(updateBookingSlotRepository: UpdateBookingSlotRepositoryProtocol = UpdateBookingSlotRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.updateBookingSlotRepository = updateBookingSlotRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute(input: SwapBookingSlotInputModel) async throws -> SwapBookingSlotModel {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

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
                                             personDetails: input.personDetails.map({
            guest in .init(personId: guest.personId,
                           reservationNumber: guest.reservationNumber,
                           guestId: guest.guestId, status: nil)
        }),
                                             activityCode: input.activityCode,
                                             shipCode: currentSailor.shipCode,
                                             activitySlotCode: input.activitySlotCode,
                                             startDate: input.startDate.toISO8601(),
                                             appointmentLinkId: input.appointmentLinkId,
                                             isSwapped: true)
        
		guard let response = try await updateBookingSlotRepository.updateBookingSlot(input: request)  else { throw VVDomainError.genericError }

        return SwapBookingSlotModel.map(from: response)
    }
}


