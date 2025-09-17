//
//  GetEateriesOpeningTimesUseCaseTests.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 23.6.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetEateriesOpeningTimesUseCaseTests: XCTestCase {
    var useCase: GetEateriesOpeningTimesUseCase!
    var mockEateriesOpeningTimesRepository: MockEateriesOpeningTimesRepository!
    var mockCurrentSailorManager: MockCurrentSailorManager!
    var mockEateriesListRepository: MockEateriesListRepository!
    var mockLocalizationManager: MockLocalizationManager!

    override func setUp() {
        super.setUp()
        mockEateriesOpeningTimesRepository = MockEateriesOpeningTimesRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        mockEateriesListRepository = MockEateriesListRepository()
        mockLocalizationManager = MockLocalizationManager(preloaded: [
            .closedText: "Closed",
            .openingTimesUnavailable: "Unavailable"
        ])

        useCase = GetEateriesOpeningTimesUseCase(
            eateriesOpeningTimesRepository: mockEateriesOpeningTimesRepository,
            currentSailorManager: mockCurrentSailorManager,
            eateriesListRepository: mockEateriesListRepository,
            localizationManager: mockLocalizationManager
        )
    }

    override func tearDown() {
        useCase = nil
        mockEateriesOpeningTimesRepository = nil
        mockCurrentSailorManager = nil
        mockEateriesListRepository = nil
        mockLocalizationManager = nil
        super.tearDown()
    }

    func testGetEateriesOpeningTimesSuccess() async throws {

        mockCurrentSailorManager.lastSailor = CurrentSailor.sample()
                mockEateriesListRepository.mockEateriesList =  EateriesList.sample()
                    .copy(bookable: [ .sample().copy(name: "The Wake", externalId: "1"),
                                      .sample().copy(name: "Closed Resto", externalId: "2")])
                mockEateriesOpeningTimesRepository.mockResponse = EateriesOpeningTimes.sample

        // Act
        let result = try await useCase.execute(date: Date())

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result.venues.first?.restaurants.first?.operationalHours, "08:00 - 10:00")
        XCTAssertEqual(result.venues.first?.restaurants.last?.operationalHours, "Closed") // if state = .closed
    }

    func testGetEateriesOpeningTimesFailure() async throws {
        mockEateriesOpeningTimesRepository.mockResponse = nil
        mockEateriesOpeningTimesRepository.shouldThrowError = true

        do {
            _ = try await useCase.execute(date: Date())
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
