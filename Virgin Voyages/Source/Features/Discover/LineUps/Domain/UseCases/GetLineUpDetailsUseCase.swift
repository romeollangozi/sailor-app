//
//  GetLineUpDetailsUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 8.5.25.
//

protocol GetLineUpDetailsUseCaseProtocol {
	func execute(eventId: String, slotId: String) async throws -> LineUpEvents.EventItem
}

final class GetLineUpDetailsUseCase: GetLineUpDetailsUseCaseProtocol {
	private let lineUpRepository: LineUpRepositoryProtocol
	private let currentSailorManager: CurrentSailorManagerProtocol
	
	init(lineUpRepository: LineUpRepositoryProtocol = LineUpRepository(),
		 currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.lineUpRepository = lineUpRepository
		self.currentSailorManager = currentSailorManager
	}
	
	func execute(eventId: String, slotId: String) async throws -> LineUpEvents.EventItem {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let lineUp = try await lineUpRepository.fetchLineUpDetails(eventId: eventId,
																		 slotId: slotId,
																		 reservationGuestId: currentSailor.reservationGuestId,
																		 voyageNumber: currentSailor.voyageNumber,
																		 reservationNumber: currentSailor.reservationNumber,
																		 shipCode: currentSailor.shipCode) else {
			throw VVDomainError.genericError
		}
		
		return lineUp
	}
}
