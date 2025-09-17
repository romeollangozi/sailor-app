//
//  GetShoreThingsListUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 15.5.25.
//

import Foundation

protocol GetShoreThingsListUseCaseProtocol {
	func execute(portCode: String, arrivalDateTime: Date?, departureDateTime: Date?, useCache: Bool) async throws -> ShoreThingsList
}

final class GetShoreThingsListUseCase: GetShoreThingsListUseCaseProtocol {
	private let currentSailorManager: CurrentSailorManagerProtocol
	private let shoreThingsRepository: ShoreThingsRepositoryProtocol
	
	init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		 shoreThingsRepository: ShoreThingsRepositoryProtocol = ShoreThingsRepository()) {
		self.currentSailorManager = currentSailorManager
		self.shoreThingsRepository = shoreThingsRepository
	}
	
	func execute(portCode: String, arrivalDateTime: Date?, departureDateTime: Date?, useCache: Bool) async throws -> ShoreThingsList {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			throw VVDomainError.unauthorized
		}

		let dateRange = ShoreThingDateRangeHelper.getShoreThingDateRange(arrivalDateTime: arrivalDateTime, departureDateTime: departureDateTime)

		guard let response = try await shoreThingsRepository.fetchShoreThingsList(
			portCode: portCode,
			startDate: dateRange.start,
			endDate:  dateRange.end,
			reservationGuestId: currentSailor.reservationGuestId,
			voyageNumber: currentSailor.voyageNumber,
			reservationNumber: currentSailor.reservationNumber,
			useCache: useCache
		) else {
			throw VVDomainError.genericError
		}

		return response
	}
}

struct ShoreThingDateRangeHelper {
	static func getShoreThingDateRange(arrivalDateTime: Date?, departureDateTime: Date?) -> (start: Date, end: Date) {
		if let arrivalDateTime = arrivalDateTime, let departureDateTime = departureDateTime {
			// Both dates available - use them as-is
			return (arrivalDateTime.toUTCDateTime(), departureDateTime.toUTCDateTime())
		} else if let arrivalDateTime = arrivalDateTime {
			// Only arrival date - start of arrival, end is end of arrival day
			let endDateTime = arrivalDateTime.setTimeToEndOfTheDay()
			return (arrivalDateTime.toUTCDateTime(), endDateTime)
		} else if let departureDateTime = departureDateTime {
			// Only departure date - start of departure, end is end of departure day
			let endDateTime = departureDateTime.setTimeToEndOfTheDay()
			return (departureDateTime.toUTCDateTime(), endDateTime)
		} else {
			let now = Date().toUTCDateTime()
			let endDateTime = now.setTimeToEndOfTheDay()
			return (now, endDateTime)
		}
	}
}
