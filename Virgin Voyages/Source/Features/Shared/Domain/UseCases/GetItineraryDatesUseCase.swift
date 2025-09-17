//
//  GetItineraryDatesUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 26.3.25.
//

protocol GetItineraryDatesUseCaseProtocol {
	func execute() -> [ItineraryDay]
}

final class GetItineraryDatesUseCase: GetItineraryDatesUseCaseProtocol {
	
	private let currentSailorManager: CurrentSailorManagerProtocol
	
	init(currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager()) {
		self.currentSailorManager = currentSailorManager
	}
	
	func execute() -> [ItineraryDay] {
		guard let currentSailor = currentSailorManager.getCurrentSailor() else {
			return []
		}
		return currentSailor.itineraryDays
	}
}
