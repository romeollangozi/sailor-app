//
//  CancelTreatmentAppointmentUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 10.2.25.
//


protocol CancelTreatmentAppointmentUseCaseProtocol {
    func execute(inputModel: CancelAppointmentInputModel) async throws -> CancelAppointment
}

final class CancelTreatmentAppointmentUseCase: CancelTreatmentAppointmentUseCaseProtocol {
    
    private let cancelAppointmentRepository: CancelAppointmentRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
	private let lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol

    init(
		cancelAppointmentRepository: CancelAppointmentRepositoryProtocol = CancelAppointmentRepository(),
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		lastKnownSailorConnectionLocationRepository: LastKnownSailorConnectionLocationRepositoryProtocol = LastKnownSailorConnectionLocationRepository()
	) {
        self.cancelAppointmentRepository = cancelAppointmentRepository
        self.currentSailorManager = currentSailorManager
        self.lastKnownSailorConnectionLocationRepository = lastKnownSailorConnectionLocationRepository
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

		let sailorLocation = lastKnownSailorConnectionLocationRepository.fetchLastKnownSailorConnectionLocation()
        switch sailorLocation {
        case .ship:
            return try await cancelAppointmentRepository.cancelAppointment(input: input)
        case .shore:
            return try await cancelAppointmentRepository.cancelAppointmentForPreCruise(input: input)
        }
        
    }
}
