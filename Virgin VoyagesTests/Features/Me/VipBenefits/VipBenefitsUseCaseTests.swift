//
//  VipBenefitsUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.3.25.
//

import XCTest
@testable import Virgin_Voyages

class GetVipBenefitsUseCaseTests: XCTestCase {

	var mockVipBenefitsRepository: MockVipBenefitsRepository!
	var mockSailorLocationRepository: SailorLocationRepositoryMock!
	var getVipBenefitsUseCase: GetVipBenefitsUseCase!

	override func setUp() {
		super.setUp()

		// Initialize mock dependencies
		mockVipBenefitsRepository = MockVipBenefitsRepository()
		mockSailorLocationRepository = SailorLocationRepositoryMock()

		// Initialize the use case with mock dependencies
		getVipBenefitsUseCase = GetVipBenefitsUseCase(
			vipBenefitsRepository: mockVipBenefitsRepository,
			currentSailorManager: MockCurrentSailorManager(),
			lastKnownSailorConnectionLocationRepository: mockSailorLocationRepository
		)
	}

	override func tearDown() {
		mockVipBenefitsRepository = nil
		mockSailorLocationRepository = nil
		getVipBenefitsUseCase = nil
		super.tearDown()
	}

	func test_execute_returnsVipBenefits() async throws {

		mockVipBenefitsRepository.mockResponse = VipBenefits(
			benefits: [
				VipBenefits.Benefit(sequence: "1", iconUrl: "https://example.com/icon1.png", summary: "Exclusive Access to VIP Lounge"),
				VipBenefits.Benefit(sequence: "2", iconUrl: "https://example.com/icon2.png", summary: "Early Bird Booking for Events")
			],
			supportEmailAddress: "support@virginvoyages.com"
		)

		let expectedVipBenefits = VipBenefitsModel(
			benefits: mockVipBenefitsRepository.mockResponse?.benefits ?? [],
			supportEmailAddress: "support@virginvoyages.com",
			title: "VIP Benefits",
			subtitle: "Exclusive VIP Access",
			contactTitle: "Contact your Rockstar Agent",
			contactImage: "ContactEmail",
			sailorLocation: .shore
		)

		try? mockSailorLocationRepository.updateSailorConnectionLocation(.shore)

		let result = try await getVipBenefitsUseCase.execute()

		XCTAssertEqual(result.benefits.count, expectedVipBenefits.benefits.count)
		XCTAssertEqual(result.supportEmailAddress, expectedVipBenefits.supportEmailAddress)
		XCTAssertEqual(result.contactTitle, expectedVipBenefits.contactTitle)
		XCTAssertEqual(result.contactImage, expectedVipBenefits.contactImage)
		XCTAssertEqual(result.sailorLocation, expectedVipBenefits.sailorLocation)
	}
}
