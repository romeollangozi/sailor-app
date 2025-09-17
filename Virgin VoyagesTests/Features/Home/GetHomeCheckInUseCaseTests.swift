//
//  GetHomeCheckInUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by TX on 17.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetHomeCheckInUseCaseTests: XCTestCase {
    
    var useCase: GetHomeCheckInUseCase!
    var mockRepository: MockHomePageRepository!
    var mockSailorManager: MockCurrentSailorManager!

    override func setUp() {
        super.setUp()
        mockRepository = MockHomePageRepository()
        mockSailorManager = MockCurrentSailorManager()
        useCase = GetHomeCheckInUseCase(
            repository: mockRepository,
            currentSailorManager: mockSailorManager
        )
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        mockSailorManager = nil
        super.tearDown()
    }

    func testExecuteWithValidResponseReturnsHomeCheckInSection() async throws {
        let expectedCheckInSection = HomeCheckInSection(
            id: "123",
            title: "Check In",
            rts: .init(title: "rts",
                       imageUrl: "",
                       description: "",
                       status: .Completed,
                       buttonLabel: "",
                       paymentNavigationUrl: "", cabinMate: nil),
            embarkation: HomeCheckInSection.EmbarkationSection(imageUrl: "",
                                                               title: "",
                                                               description: "",
                                                               status: nil,
                                                               details: HomeCheckInSection.EmbarkationSection.EmbarkationDetailsSection(sailorType: nil,
                                                                                                                                        title: "",
                                                                                                                                        imageUrl: "",
                                                                                                                                        arrivalSlot: "",
                                                                                                                                        location: "",
                                                                                                                                        coordinates: "",
                                                                                                                                        placeId: "",
                                                                                                                                        cabinType: "",
                                                                                                                                        cabinDetails: ""),
                                                               guide: HomeCheckInSection.EmbarkationSection.EmbarkationGuideSection(title: "",
                                                                                                                                    description: "",
                                                                                                                                    navigationUrl: "")),
            healthCheck: .init(imageUrl: "https://example.com/health-check.jpg",
                               title: "Test Health Check",
                               description: "Test Complete your health declaration before boarding.",
							   status: .opened),
			serviceGratuitiesSection: .init(title: "",
											description: "",
											imageUrl: "",
											status: nil)
        )
        
        mockRepository.mockHomeCheckInSection = expectedCheckInSection
        mockSailorManager.lastSailor = CurrentSailor.sample()

        let result = try await useCase.execute()

        XCTAssertNotNil(result)
        XCTAssertEqual(result.id, expectedCheckInSection.id)
        XCTAssertEqual(result.title, expectedCheckInSection.title)
    }

    func testExecuteThrowsErrorWhenRepositoryFails() async {
        mockRepository.shouldThrowError = true
        mockRepository.errorToThrow = VVDomainError.genericError
        mockSailorManager.lastSailor = CurrentSailor.sample()

        do {
            _ = try await useCase.execute()
            XCTFail("Expected error but got a successful response")
        } catch {
            XCTAssertEqual(error as? VVDomainError, VVDomainError.genericError, "Expected VVDomainError.genericError")
        }
    }

    func testExecuteThrowsErrorWhenSailorIsMissing() async {
        mockSailorManager.lastSailor = nil

        do {
            _ = try await useCase.execute()
            XCTFail("Expected error due to missing sailor")
        } catch {
            // Then
            XCTAssertEqual(error as? VVDomainError, VVDomainError.genericError, "Expected VVDomainError.genericError due to missing sailor")
        }
    }
}

