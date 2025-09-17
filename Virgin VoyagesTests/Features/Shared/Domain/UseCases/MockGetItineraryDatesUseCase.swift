//
//  MockGetItineraryDatesUseCase.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.4.25.
//

import XCTest

@testable import Virgin_Voyages

final class MockGetItineraryDatesUseCase: GetItineraryDatesUseCaseProtocol {
	var result: [ItineraryDay] = []
	func execute() -> [ItineraryDay] {
		return result
	}
}
