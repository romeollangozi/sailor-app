//
//  Add.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 2.9.25.
//

import XCTest
@testable import Virgin_Voyages

final class AddFriendUseCaseTests: XCTestCase {

	// MARK: - Properties
	private var sut: MockAddFriendUseCase!
	private var mockRepository: MockMessengerFriendsRepository!
	private var mockCurrentSailorManager: MockCurrentSailorManager!
	private var mockSailorsRepository: MockSailorRepository!

	// MARK: - Setup & Teardown
	override func setUp() {
		super.setUp()
		mockRepository = MockMessengerFriendsRepository()
		mockCurrentSailorManager = MockCurrentSailorManager()
		mockSailorsRepository = MockSailorRepository()
		sut = MockAddFriendUseCase()
	}

	override func tearDown() {
		sut = nil
		mockRepository = nil
		mockCurrentSailorManager = nil
		mockSailorsRepository = nil
		super.tearDown()
	}

	// MARK: - Test Cases
	func testExecute_WithValidSailor_SuccessfullyAddsFriendAndInvalidatesCache() async throws {
		// Given
		let connectionReservationId = "RES67890"
		let connectionReservationGuestId = "GUEST67890"
		let mockSailor = createMockSailor()

		mockCurrentSailorManager.lastSailor = mockSailor
		mockRepository.addFriendToContactsResult = .success(EmptyModel())

		// When
		let result = try await sut.execute(
			connectionReservationId: connectionReservationId,
			connectionReservationGuestId: connectionReservationGuestId
		)

		// Then
		XCTAssertTrue(result)
	}

	func testExecute_WithRepositoryAddFriendFailure_ReturnsFalse() async throws {
		// Given
		let connectionReservationId = "RES67890"
		let connectionReservationGuestId = "GUEST67890"
		let mockSailor = createMockSailor()
		mockCurrentSailorManager.lastSailor = mockSailor
		mockRepository.addFriendToContactsResult = nil

		// When
		let result = try await sut.execute(
			connectionReservationId: connectionReservationId,
			connectionReservationGuestId: connectionReservationGuestId
		)

		// Then
		XCTAssertNotNil(result)
	}

	// MARK: - Helpers
	private func createMockSailor() -> CurrentSailor {
		return CurrentSailor(
			errorState: nil,
			reservationId: "123456",
			guestId: "654321",
			reservationGuestId: "987654",
			voyageNumber: "VN001",
			reservationNumber: "RSV001",
			voyageId: "VJ001",
			shipCode: "SC001",
			embarkDate: "2024-12-28",
			debarkDate: "2025-01-05",
			startDateTime: "2024-12-28T16:00:00Z",
			endDateTime: "2025-01-05T08:00:00Z",
			shipName: "Tropical Dream",
			guestTypeCode: "VIP1",
			sailorType: .standard,
			deckPlanUrl: "",
			itineraryDays: [
				ItineraryDay(
					itineraryDay: 1,
					isSeaDay: false,
					portCode: "MIA",
					day: "Saturday",
					dayOfWeek: "S",
					dayOfMonth: "28",
					date: ISO8601DateFormatter().date(from: "2024-12-28T00:00:00Z")!,
					portName: "Miami"
				),
				ItineraryDay(
					itineraryDay: 2,
					isSeaDay: true,
					portCode: "",
					day: "Sunday",
					dayOfWeek: "S",
					dayOfMonth: "29",
					date: ISO8601DateFormatter().date(from: "2024-12-29T00:00:00Z")!,
					portName: ""
				),
				ItineraryDay(
					itineraryDay: 3,
					isSeaDay: false,
					portCode: "POP",
					day: "Monday",
					dayOfWeek: "M",
					dayOfMonth: "30",
					date: ISO8601DateFormatter().date(from: "2024-12-30T00:00:00Z")!,
					portName: "Puerto Plata"
				)
			],
			cabinNumber: "8086Z",
			externalRefId: nil
		)
	}
}
