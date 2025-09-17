//
//  GetEateryConflictsUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 28.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetEateryConflictsUseCaseTests: XCTestCase {
	var useCase: GetEateryConflictsUseCaseProtocol!
	var mockEateryConflictRepository: MockEateryConflictRepository!
	var mockCurrentSailorManager: MockCurrentSailorManager!
	var mockEateriesListRepository: MockEateriesListRepository!
	var mockSailorsRepository: MockSailorsRepository!
	
	override func setUp() {
		super.setUp()
		mockEateryConflictRepository = MockEateryConflictRepository()
		mockCurrentSailorManager = MockCurrentSailorManager()
		mockEateriesListRepository = MockEateriesListRepository()
		mockSailorsRepository = MockSailorsRepository()
		
		useCase = GetEateryConflictsUseCase(
			eateryConflictRepository: mockEateryConflictRepository,
			currentSailorManager: mockCurrentSailorManager,
			eateriesListRepository: mockEateriesListRepository,
			sailorsRepository: mockSailorsRepository
		)
	}
	
	override func tearDown() {
		useCase = nil
		mockEateryConflictRepository = nil
		mockCurrentSailorManager = nil
		mockEateriesListRepository = nil
		mockSailorsRepository = nil
		super.tearDown()
	}
	
	func testExecuteShouldReturnsNoConflicts() async throws {
		let input = EateryConflictsInputModel.sampleWithDinner()
		
		mockEateryConflictRepository.conflictResponse = EateryConflicts.sample().copy(type: "")
		
		let result = try await useCase.execute(input: input)
		
		XCTAssertNil(result.conflict)
	}
	
	func testExecuteShouldReturnsHardConflict() async throws {
		let input = EateryConflictsInputModel.sampleWithDinner()
		mockEateryConflictRepository.conflictResponse = EateryConflicts.sample().copy(type: "HARD")
		
		let result = try await useCase.execute(input: input)
		
		XCTAssertEqual(result.conflict?.title, "One or more of your party already has a dinner reservation on \(input.startDateTime.weekdayName())")
		XCTAssertEqual(result.conflict?.description, "You can only book one restaurant per night. We limit bookings so all our sailors have a chance to eat everywhere.")
		XCTAssertTrue(result.conflict?.isClash ?? false)
		XCTAssertFalse(result.conflict?.isSoftClash ?? true)
	}
	
	func testExecuteShouldReturnsRepeatConflict() async throws {
		let eateries = EateriesList.sample()
			.copy(bookable: [.sample().copy(name: "The Wake", externalId:"1")])
		mockEateriesListRepository.mockEateriesList = eateries
		
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(itineraryDays: [.sample()])
		
		let input = EateryConflictsInputModel.sampleWithDinner().copy(activityCode: "1")
				
		mockEateryConflictRepository.conflictResponse = EateryConflicts.sample()
			.copy(type: "REPEAT")
		
		let result = try await useCase.execute(input: input)
		
		XCTAssertEqual(result.conflict?.title, "One or more of your party already has a dinner reservation at The Wake")
		XCTAssertEqual(result.conflict?.description, "We limit bookings so all our sailors have a chance to eat everywhere. \n \nHowever it doesn’t mean you can’t eat at The Wake again. We always reserve some walkins, so you can pop by and see if we have a table spare.")
		XCTAssertTrue(result.conflict?.isClash ?? false)
		XCTAssertFalse(result.conflict?.isSoftClash ?? true)
	}
	
	func testExecuteShouldReturnsRepeatConflictForBigVoyage() async throws {
		let eateries = EateriesList.sample()
			.copy(bookable: [.sample().copy(name: "The Wake", externalId:"1")])
		mockEateriesListRepository.mockEateriesList = eateries
		
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(itineraryDays:
																			[.sample(), .sample(), .sample(), .sample(), .sample(), .sample(), .sample()])
		
		let input = EateryConflictsInputModel.sampleWithDinner().copy(activityCode: "1")
				
		mockEateryConflictRepository.conflictResponse = EateryConflicts.sample()
			.copy(type: "REPEAT")
		
		let result = try await useCase.execute(input: input)
		
		XCTAssertEqual(result.conflict?.title, "One or more of your party already has 2 dinner reservations at The Wake")
		XCTAssertEqual(result.conflict?.description, "We limit bookings so all our sailors have a chance to eat everywhere. \n \nHowever it doesn’t mean you can’t eat at The Wake again. We always reserve some walkins, so you can pop by and see if we have a table spare.")
		XCTAssertTrue(result.conflict?.isClash ?? false)
		XCTAssertFalse(result.conflict?.isSoftClash ?? true)
	}

	func testExecuteShouldReturnSoftConflictWhenCurrentSailor() async throws {
		let input = EateryConflictsInputModel.sampleWithDinner()
		
		let sailors = SailorModel.samples()
		
		mockSailorsRepository.sailors = sailors
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(reservationGuestId: sailors[0].reservationGuestId)
		mockEateryConflictRepository.conflictResponse = EateryConflicts.sample().copy(details: EateryConflicts.Details.sample().copy(personDetails:[.init(personId: sailors[0].reservationGuestId, count: 1)]), type: "SOFT")
		
		let result = try await useCase.execute(input: input)

		XCTAssertEqual(result.conflict!.title, "One or more of your party already is booked")
		XCTAssertEqual(result.conflict!.description, "You are double booked at this time—you can proceed, but you may not be able to be in two places at once.")
		XCTAssertTrue(result.conflict!.isClash)
		XCTAssertTrue(result.conflict!.isSoftClash)
		XCTAssertFalse(result.conflict!.isSwap)
	}
	
	func testExecuteShouldReturnSoftConflictWhenMultipleSailors() async throws {
		let input = EateryConflictsInputModel.sampleWithDinner()
		
		let sailors = SailorModel.samples()
		
		mockSailorsRepository.sailors = sailors
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample()
		mockEateryConflictRepository.conflictResponse = EateryConflicts.sample().copy(details: EateryConflicts.Details.sample().copy(personDetails: sailors.map { .init(personId: $0.reservationGuestId, count: 1) }), type: "SOFT")
		
		let result = try await useCase.execute(input: input)
		
		let conflictSailorNames = sailors.map { $0.name }.joined(separator: ", ")
		let expectedDescription = "\(conflictSailorNames) are double booked at this time—you can proceed, but they may not be able to be in two places at once."
		
		XCTAssertEqual(result.conflict!.title, "One or more of your party already is booked")
		XCTAssertEqual(result.conflict!.description, expectedDescription)
		XCTAssertTrue(result.conflict!.isClash)
		XCTAssertTrue(result.conflict!.isSoftClash)
		XCTAssertFalse(result.conflict!.isSwap)
	}
	
	func testExecuteShouldReturnSoftConflictsWhenOtherSingleSailor() async throws {
		let input = EateryConflictsInputModel.sampleWithDinner()
		
		let sailor = SailorModel.sample()
		
		mockSailorsRepository.sailors = [sailor]
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample()
		mockEateryConflictRepository.conflictResponse = EateryConflicts.sample().copy(details: EateryConflicts.Details.sample().copy(personDetails: [.init(personId: sailor.reservationGuestId, count: 1)]), type: "SOFT")
		
		let result = try await useCase.execute(input: input)
		
		let expectedDescription = "\(sailor.name) is double booked at this time—you can proceed, but they may not be able to be in two places at once."
		
		XCTAssertEqual(result.conflict!.title, "One or more of your party already is booked")
		XCTAssertEqual(result.conflict!.description, expectedDescription)
		XCTAssertTrue(result.conflict!.isClash)
		XCTAssertTrue(result.conflict!.isSoftClash)
		XCTAssertFalse(result.conflict!.isSwap)
	}
	
	func testExecuteShouldReturnSoftConflictWhenMultipleSailorsIncludingCurrentSailor() async throws {
		let input = EateryConflictsInputModel.sampleWithDinner()
		
		let sailors = SailorModel.samples()
		
		mockSailorsRepository.sailors = sailors
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(reservationGuestId: sailors[0].reservationGuestId)
		mockEateryConflictRepository.conflictResponse = EateryConflicts.sample().copy(details: EateryConflicts.Details.sample().copy(personDetails: sailors.map { .init(personId: $0.reservationGuestId, count: 1) }), type: "SOFT")
		
		let result = try await useCase.execute(input: input)
		
		let expectedDescription = "You, \(sailors[1].name) are double booked at this time—you can proceed, but they may not be able to be in two places at once."
		
		XCTAssertEqual(result.conflict!.title, "One or more of your party already is booked")
		XCTAssertEqual(result.conflict!.description, expectedDescription)
		XCTAssertTrue(result.conflict!.isClash)
		XCTAssertTrue(result.conflict!.isSoftClash)
		XCTAssertFalse(result.conflict!.isSwap)
	}
	
	func testExecuteShouldReturnSwapConflictWhenDifferentDays() async throws {
		let eateries = EateriesList.sample()
			.copy(bookable: [
				.sample().copy(name: "The Wake", externalId:"1"),
				.sample().copy(name: "Test Kitchen", externalId:"2")]
			)
		mockEateriesListRepository.mockEateriesList = eateries
		
		let input = EateryConflictsInputModel.sampleWithDinner().copy(activityCode: "1")
		
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample()
				
		let details = EateryConflicts.Details.sample()
			.copy(cancellableRestaurantExternalId: eateries.bookable[0].externalId,
				  cancellableAppointmentDateTime: Date(),
				  swappableRestaurantExternalId: eateries.bookable[1].externalId,
				  swappableAppointmentDateTime: Date())
		
		mockEateryConflictRepository.conflictResponse = EateryConflicts.sample().copy(details:details, type: "SWAP_SAME_RESTAURANT_BY_DAY")
		
		let result = try await useCase.execute(input: input)
		
		XCTAssertEqual(result.conflict?.title, "Your party already has a dinner reservation for The Wake")
		XCTAssertEqual(result.conflict?.description, "You can only book dinner once per restaurant per voyage")
		XCTAssertFalse(result.conflict!.isClash)
		XCTAssertFalse(result.conflict!.isSoftClash)
		XCTAssertTrue(result.conflict!.isSwap)
	}
	
	func testExecuteShouldReturnSwapConflictWhenSameDay() async throws {
		let eateries = EateriesList.sample()
			.copy(bookable: [
				.sample().copy(name: "The Wake", externalId:"1"),
				.sample().copy(name: "Test Kitchen", externalId:"2")]
			)
		mockEateriesListRepository.mockEateriesList = eateries
		
		let input = EateryConflictsInputModel.sampleWithDinner().copy(activityCode: "1")
		
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample()
				
		let details = EateryConflicts.Details.sample()
			.copy(cancellableRestaurantExternalId: eateries.bookable[0].externalId,
				  cancellableAppointmentDateTime: Date(),
				  swappableRestaurantExternalId: eateries.bookable[1].externalId,
				  swappableAppointmentDateTime: Date())
		
		mockEateryConflictRepository.conflictResponse = EateryConflicts.sample().copy(details:details, type: "SWAP_DIFFERENT_RESTAURANT_SAME_DAY")
		
		let result = try await useCase.execute(input: input)
		
		XCTAssertEqual(result.conflict?.title, "Your party already has a dinner reservation on \(input.startDateTime.weekdayName())")
		XCTAssertEqual(result.conflict?.description, "You can only book one restaurant per night")
		XCTAssertFalse(result.conflict!.isClash)
		XCTAssertFalse(result.conflict!.isSoftClash)
		XCTAssertTrue(result.conflict!.isSwap)
	}
}
