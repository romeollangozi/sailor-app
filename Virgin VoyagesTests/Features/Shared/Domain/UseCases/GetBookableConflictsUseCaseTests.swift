//
//  GetBookableConflictsUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 7.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetBookableConflictsUseCaseTests: XCTestCase {
	var mockCurrentSailorManager: MockCurrentSailorManager!
	var mockBookableConflictsRepository : MockBookableConflictsRepository!
	var mockSailorsRepository: MockSailorsRepository!
	var useCase: GetBookableConflictsUseCaseProtocol!
	
	override func setUp() {
		super.setUp()
		mockCurrentSailorManager = MockCurrentSailorManager()
		mockBookableConflictsRepository = MockBookableConflictsRepository()
		mockSailorsRepository = MockSailorsRepository()
		
		useCase = GetBookableConflictsUseCase(currentSailorManager: mockCurrentSailorManager, bookableConflictsRepository: mockBookableConflictsRepository, sailorsRepository: mockSailorsRepository)
	}
	
	override func tearDown() {
		mockCurrentSailorManager = nil
		mockBookableConflictsRepository = nil
		mockSailorsRepository = nil
		super.tearDown()
	}
	
	func testExecuteShouldReturnHardConflictOnlyForLoggedInUser() async throws {
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(reservationGuestId: "1")
		mockSailorsRepository.sailors = [SailorModel.sample().copy(reservationGuestId: "1", name: "You", profileImageUrl: "photo1.jpg", isCabinMate: true, isLoggedInSailor: true)]
		mockBookableConflictsRepository.result = [.init(slotId: "1", slotStatus: ConflictState.hard, sailors: [.init(reservationGuestId: "1", status: .hard, bookableType: .entertainment)])]
		
		let result = try await useCase.execute(input: .empty())
		let hardConflictDetais = result.first?.getHardConflictDetails(sailorIds: mockSailorsRepository.sailors.getOnlyReservationGuestIds())
		
		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(hardConflictDetais?.description, "You already have something booked at this time. You can't double book.")
		XCTAssertEqual(hardConflictDetais?.sailorsNames, ["You"])
		XCTAssertEqual(hardConflictDetais?.title, "Hold Up")
		XCTAssertEqual(hardConflictDetais?.sailorsPhotos, ["photo1.jpg"])
		XCTAssertEqual(hardConflictDetais?.buttonText, "You have a clash")
	}
	
	func testExecuteShouldReturnHardConflictForLoggedInUserAndOtherSailor() async throws {
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(reservationGuestId: "1")
		mockSailorsRepository.sailors = [
			SailorModel.sample().copy(reservationGuestId: "1", name: "You", profileImageUrl: "photo1.jpg", isLoggedInSailor: true),
			SailorModel.sample().copy(reservationGuestId: "2", name: "John", profileImageUrl: "photo2.jpg", isLoggedInSailor: false)
		]

		mockBookableConflictsRepository.result = [
			.init(
				slotId: "1",
				slotStatus: .hard,
				sailors: [
					.init(reservationGuestId: "1", status: .hard, bookableType: .entertainment),
					.init(reservationGuestId: "2", status: .hard, bookableType: .entertainment)
				]
			)
		]

		let result = try await useCase.execute(input: .empty())
		let hardConflictDetails = result.first?.getHardConflictDetails(sailorIds: mockSailorsRepository.sailors.getOnlyReservationGuestIds())

		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(hardConflictDetails?.description, "You and John already have something booked at this time. You can't double book them.")
		XCTAssertEqual(hardConflictDetails?.sailorsNames, ["You", "John"])
		XCTAssertEqual(hardConflictDetails?.title, "Hold Up")
		XCTAssertEqual(hardConflictDetails?.sailorsPhotos, ["photo1.jpg", "photo2.jpg"])
		XCTAssertEqual(hardConflictDetails?.buttonText, "2 sailors have clashes")
	}

	func testExecuteShouldReturnHardConflictOnlyForOtherSailor() async throws {
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(reservationGuestId: "1")
		mockSailorsRepository.sailors = [
			SailorModel.sample().copy(reservationGuestId: "1", name: "You", profileImageUrl: "photo1.jpg", isLoggedInSailor: true),
			SailorModel.sample().copy(reservationGuestId: "2", name: "John", profileImageUrl: "photo2.jpg", isLoggedInSailor: false)
		]
		mockBookableConflictsRepository.result = [.init(slotId: "1", slotStatus: ConflictState.hard,
														sailors: [.init(reservationGuestId: "2", status: .hard, bookableType: .entertainment)]),]
		
		let result = try await useCase.execute(input: .empty())
		let hardConflictDetais = result.first?.getHardConflictDetails(sailorIds: mockSailorsRepository.sailors.getOnlyReservationGuestIds())
		
		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(hardConflictDetais?.description, "John already has something booked at this time. You can't double book them.")
		XCTAssertEqual(hardConflictDetais?.sailorsNames, ["John"])
		XCTAssertEqual(hardConflictDetais?.title, "Hold Up")
		XCTAssertEqual(hardConflictDetais?.sailorsPhotos, ["photo2.jpg"])
		XCTAssertEqual(hardConflictDetais?.buttonText, "John has a clash")
	}
	
	func testExecuteShouldReturnHardConflictForOtherSailors() async throws {
		mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(reservationGuestId: "1")
		mockSailorsRepository.sailors = [
			SailorModel.sample().copy(reservationGuestId: "2", name: "Anna", profileImageUrl: "photo1.jpg", isLoggedInSailor: true),
			SailorModel.sample().copy(reservationGuestId: "3", name: "John", profileImageUrl: "photo2.jpg", isLoggedInSailor: false)
		]

		mockBookableConflictsRepository.result = [
			.init(
				slotId: "1",
				slotStatus: .hard,
				sailors: [
					.init(reservationGuestId: "2", status: .hard, bookableType: .entertainment),
					.init(reservationGuestId: "3", status: .hard, bookableType: .entertainment)
				]
			)
		]

		let result = try await useCase.execute(input: .empty())
		let hardConflictDetails = result.first?.getHardConflictDetails(sailorIds: mockSailorsRepository.sailors.getOnlyReservationGuestIds())

		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(hardConflictDetails?.description, "Anna and John already have something booked at this time. You can't double book them.")
		XCTAssertEqual(hardConflictDetails?.sailorsNames, ["Anna", "John"])
		XCTAssertEqual(hardConflictDetails?.title, "Hold Up")
		XCTAssertEqual(hardConflictDetails?.sailorsPhotos, ["photo1.jpg", "photo2.jpg"])
		XCTAssertEqual(hardConflictDetails?.buttonText, "2 sailors have clashes")
	}
}
