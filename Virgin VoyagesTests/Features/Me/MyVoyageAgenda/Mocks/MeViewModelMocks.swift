//
//  MockGetMyVoyageHeaderUseCase.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 29.5.25.
//

import XCTest
@testable import Virgin_Voyages

// MARK: - Mocks

class MockGetMyVoyageHeaderUseCase: GetMyVoyageHeaderUseCaseProtocol {
	var executeResult: MyVoyageHeaderModel?
	var lastUseCacheValue: Bool?

	func execute(useCache: Bool) async throws -> MyVoyageHeaderModel {
		lastUseCacheValue = useCache
		return executeResult ?? MyVoyageHeaderModel.empty()
	}
}

class MockGetMyVoyageAgendaUseCase: GetMyVoyageAgendaUseCaseProtocol {
	var executeResult: MyVoyageAgenda?
	var lastUseCacheValue: Bool?

	func execute(useCache: Bool) async throws -> MyVoyageAgenda {
		lastUseCacheValue = useCache
		return executeResult ?? MyVoyageAgenda.empty()
	}
}

class MockGetMyVoyageAddOnsUseCase: GetMyVoyageAddOnsUseCaseProtocol {
	var executeResult: MyVoyageAddOns?
	var lastUseCacheValue: Bool?

	func execute(useCache: Bool) async throws -> MyVoyageAddOns {
		lastUseCacheValue = useCache
		return executeResult ?? MyVoyageAddOns.empty()
	}
}

class MockGetSailingModeUseCase: GetSailingModeUseCaseProtocol {
	var executeResult: SailingMode = .undefined

	func execute() async throws -> SailingMode {
		return executeResult
	}
}

class MockGetSailorDateAndTimeUseCase: GetSailorDateAndTimeUseCaseProtocol {
	var executeResult: Date = Date()

	func execute() async -> Date {
		return executeResult
	}
}

class MeMockGetItineraryDatesUseCase: GetItineraryDatesUseCaseProtocol {
	var executeResult: [ItineraryDay] = []

	func execute() -> [ItineraryDay] {
		return executeResult
	}
}
