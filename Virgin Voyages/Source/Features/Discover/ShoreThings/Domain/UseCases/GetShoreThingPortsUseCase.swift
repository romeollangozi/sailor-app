//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.5.25.
//

import Foundation

protocol GetShoreThingPortsUseCaseProtocol {
	func execute(useCache: Bool) async throws -> ShoreThingPorts
}

extension GetShoreThingPortsUseCaseProtocol {
	func execute() async throws -> ShoreThingPorts {
		return try await self.execute(useCache: true)
	}
}

class GetShoreThingPortsUseCase: GetShoreThingPortsUseCaseProtocol {
    private let shoreThingsRepository: ShoreThingsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    
    init(shoreThingsRepository: ShoreThingsRepositoryProtocol = ShoreThingsRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
        self.shoreThingsRepository = shoreThingsRepository
        self.currentSailorManager = currentSailorManager
    }
    
    func execute(useCache: Bool) async throws -> ShoreThingPorts {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		if let response = try await shoreThingsRepository.fetchShoreThingPorts(reservationId: currentSailor.reservationId,
																			   reservationGuestId: currentSailor.reservationGuestId,
																			   shipCode: currentSailor.shipCode,
																			   voyageNumber: currentSailor.voyageNumber,
																			   useCache: useCache) {
            
            let items: [ShoreThingPort] = response.items.map {
                ShoreThingPort(
                    sequence: $0.sequence,
                    name: $0.name,
                    code: $0.code,
                    slug: $0.slug,
                    imageURL: $0.imageURL,
                    dayType: $0.dayType,
                    departureDateTime: $0.departureDateTime,
                    arrivalDateTime: $0.arrivalDateTime,
                    departureArrivalDateText: $0.departureArrivalDateText,
                    departureArrivalTimeText: $0.departureArrivalTimeText,
                    guideText: $0.guideText,
					actionURL: $0.actionURL
                )
            }
            
            return ShoreThingPorts(items: items, leadTime: response.leadTime)
        } else {
            throw VVDomainError.genericError
        }
    }
}
