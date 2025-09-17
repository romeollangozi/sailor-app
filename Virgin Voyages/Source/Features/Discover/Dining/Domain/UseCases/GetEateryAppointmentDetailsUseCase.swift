//
//  GetEateryAppointmentDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.4.25.
//

protocol GetEateryAppointmentDetailsUseCaseProtocol {
	func execute(appointmentId: String) async throws -> EateryAppointmentDetails
}

final class GetEateryAppointmentDetailsUseCase : GetEateryAppointmentDetailsUseCaseProtocol {
	private let eateriesAppointmentRepository: EateriesAppointmentRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	
	init(eateriesAppointmentRepository: EateriesAppointmentRepositoryProtocol = EateriesAppointmentRepository(),
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.eateriesAppointmentRepository = eateriesAppointmentRepository
		self.currentSailorManager = currentSailorManager
	}
	
	func execute(appointmentId: String) async throws -> EateryAppointmentDetails {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let response = try await eateriesAppointmentRepository.fetchEateryAppointmentDetails(appointmentId: appointmentId, reservationGuestId: currentSailor.reservationGuestId) else { throw VVDomainError.genericError }
		
		return response
	}
}
