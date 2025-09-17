//
//  TestGetProfileSettingsLandingScreenUseCase.swift
//  Virgin VoyagesTests
//
//  Created by Timur Xhabiri on 31.10.24.
//

import XCTest
@testable import Virgin_Voyages

final class GetProfileSettingsLandingScreenUseCaseTests: XCTestCase {
	private var mockCurrentSailorManager: MockCurrentSailorManager!
	private var mockLastKnownSailorConnectionLocationRepository : MockLastKnownSailorConnectionLocationRepository!
	private var mockRepository: MockProfileSettingsRepository!
	private var useCase: GetProfileSettingsLandingScreenUseCaseProtocol!

	override func setUp() {
		super.setUp()
		mockCurrentSailorManager = MockCurrentSailorManager()
		mockRepository = MockProfileSettingsRepository()
		mockLastKnownSailorConnectionLocationRepository = MockLastKnownSailorConnectionLocationRepository()

		useCase = GetProfileSettingsLandingScreenUseCase(currentSailorManager: mockCurrentSailorManager,
														 profileSettingsRepository: mockRepository,
														 lastKnownSailorConnectionLocationRepository: mockLastKnownSailorConnectionLocationRepository)
	}

	override func tearDown() {
		mockCurrentSailorManager = nil
		mockRepository = nil
		mockLastKnownSailorConnectionLocationRepository = nil
		useCase = nil
		super.tearDown()
	}

	func testExecuteShouldReturnRestrictedOnlyTermsAndConditionAndSwitchVoyageInSequence() async {
		mockRepository.mockMenuItems = [
			.sample().copy(id: .personalInformation, sequence: 1),
			.sample().copy(id: .termsAndConditions, sequence: 2),
			.sample().copy(id: .switchVoyage, sequence: 3),
		]

		let result = await useCase.execute()

		switch result {
		case .success(let content):
			XCTAssertEqual(content.menuItems.count, 2)

			XCTAssertTrue(content.menuItems[0].id == .termsAndConditions)
			XCTAssertTrue(content.menuItems[1].id == .switchVoyage)
		case .failure(_):
			XCTFail("Expected success, but got failure")
		}
	}

	func testExecuteWhenOnShipShouldReturnRestrictedOnlyTermsAndConditionAndSetCasinoPin() async {
		mockRepository.mockMenuItems = [
			.sample().copy(id: .personalInformation, sequence: 1),
			.sample().copy(id: .termsAndConditions, sequence: 2),
			.sample().copy(id: .switchVoyage, sequence: 3),
		]

		mockLastKnownSailorConnectionLocationRepository.lastSailorLocation = .ship

		let result = await useCase.execute()

		switch result {
		case .success(let content):
			XCTAssertEqual(content.menuItems.count, 2)

			XCTAssertTrue(content.menuItems[0].id == .setCasinoPin)
			XCTAssertTrue(content.menuItems[1].id == .termsAndConditions)
		case .failure(_):
			XCTFail("Expected success, but got failure")
		}
	}

	func testExecuteWhenThrowsShouldReturnFailure() async {
		mockRepository.shouldReturnError = true

		let result = await useCase.execute()

		switch result {
		case .success:
			XCTFail("Expected failure, but got success")
		case .failure(let error):
			XCTAssertEqual(error, .genericError)
		}
	}
}
