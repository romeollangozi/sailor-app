//
//  FetchActivityAppointment.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 22.11.24.
//

import Foundation

protocol GetShoreThingReceiptDetailsUseCaseProtocol {
	func  execute(appointmentId: String) async throws -> ShoreThingReceiptDetails
}

final class GetShoreThingReceiptDetailsUseCase: GetShoreThingReceiptDetailsUseCaseProtocol {
	private let authenticationService: AuthenticationServiceProtocol
	private let activitiesGuestRepository: ActivitiesGuestRepositoryProtocol
	private let activityAppointmentDetailsRepository: ShoreThingsRepositoryProtocol
	private let localizationManager: LocalizationManagerProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol

	init(authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared,
		 activitiesGuestRepository: ActivitiesGuestRepositoryProtocol = ActivitiesGuestRepository(),
		 activityAppointmentDetailsRepository: ShoreThingsRepositoryProtocol = ShoreThingsRepository(),
		 localizationManager: LocalizationManagerProtocol = LocalizationManager.shared,
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.authenticationService = authenticationService
		self.activitiesGuestRepository = activitiesGuestRepository
		self.activityAppointmentDetailsRepository = activityAppointmentDetailsRepository
		self.localizationManager = localizationManager
		self.currentSailorManager = currentSailorManager
	}
	
	func execute(appointmentId: String) async throws -> ShoreThingReceiptDetails {
		guard let response = try await activityAppointmentDetailsRepository.fetchReceiptDetails(appointmentId: appointmentId) else { throw VVDomainError.genericError }
		
		return response
	}
}

