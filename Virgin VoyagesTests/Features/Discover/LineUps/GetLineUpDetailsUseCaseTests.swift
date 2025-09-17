//
//  GetLineUpDetailsUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 8.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetLineUpDetailsUseCaseTests: XCTestCase {
	var mockCurrentSailorManager: MockCurrentSailorManager!
	var mockRepository: MockLineUpRepository!
	var useCase: GetLineUpDetailsUseCaseProtocol!

	override func setUp() {
		super.setUp()
		mockRepository = MockLineUpRepository()
		
		mockCurrentSailorManager = MockCurrentSailorManager()
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample()
		
		useCase = GetLineUpDetailsUseCase(lineUpRepository: mockRepository, currentSailorManager: mockCurrentSailorManager)
	}

	override func tearDown() {
		mockRepository = nil
		useCase = nil
		super.tearDown()
	}

	func testExecuteReturnsEventDetails() async throws {
		let mockLineUpEvents = LineUpEvents.sample()
		mockRepository.mockLineUpEvents = mockLineUpEvents
		

		let result = try await useCase.execute(eventId: "", slotId: "")

		XCTAssertNotNil(result)
		XCTAssertEqual(result, mockLineUpEvents[0].items[0])
	}
	
	func testExecuteReturnsEventDetailsShouldThrow() async throws {
		mockRepository.mockLineUpEvents = LineUpEvents.sample()
		mockRepository.shouldThrowError = true

		do {
			_ = try await useCase.execute(eventId: "", slotId: "")
			XCTFail("Expected to throw an error")
		} catch {
			XCTAssertNotNil(error)
		}
	}
}
