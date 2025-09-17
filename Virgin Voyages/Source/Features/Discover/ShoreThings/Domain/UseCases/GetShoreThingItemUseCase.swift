//
//  GetShoreThingItemUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 15.5.25.
//

import Foundation

protocol GetShoreThingItemUseCaseProtocol {
	func  execute(id: String, slotId: String, portCode: String, portStartDate: String, portEndDate: String) async throws -> ShoreThingItem
}

final class GetShoreThingItemUseCase: GetShoreThingItemUseCaseProtocol {
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let shoreThingsRepository: ShoreThingsRepositoryProtocol
	
	init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 shoreThingsRepository: ShoreThingsRepositoryProtocol = ShoreThingsRepository()) {
		self.currentSailorManager = currentSailorManager
		self.shoreThingsRepository = shoreThingsRepository
	}
	
	func execute(id: String, slotId: String, portCode: String, portStartDate: String, portEndDate: String) async throws -> ShoreThingItem {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		guard let response = try await shoreThingsRepository.fetchShoreThingItem(id: id,
																				  slotId: slotId,
																				  portCode: portCode,
																				  portStartDate: portStartDate,
																				  portEndDate: portEndDate,
																				  reservationGuestId: currentSailor.reservationGuestId,
																				  voyageNumber: currentSailor.voyageNumber,
																				 reservationNumber: currentSailor.reservationNumber) else {
			throw VVDomainError.genericError
		}
		
		return response
	}
}
	
