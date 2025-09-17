//
//  GetLineUpUseCaseTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 13.1.25.
//

import Foundation
import XCTest

@testable import Virgin_Voyages

final class GetLineUpUseCaseTests: XCTestCase {
    var useCase: GetLineUpUseCase!
    var mockCurrentSailorManager: MockCurrentSailorManager!
    var mockClock: MockClock!
    var mockLineUpRepository: MockLineUpRepository!

    override func setUp() {
        super.setUp()
        mockCurrentSailorManager = MockCurrentSailorManager()
        mockClock = MockClock()
        mockLineUpRepository = MockLineUpRepository()
        useCase = GetLineUpUseCase(lineUpRepository: mockLineUpRepository, currentSailorManager: mockCurrentSailorManager)
    }

    override func tearDown() {
        useCase = nil
        mockCurrentSailorManager = nil
        mockClock = nil
        super.tearDown()
    }

    func testExecuteShouldReturnEvents() async throws {
        let todayDate = mockClock.mockNow
        let tomorrowDate = mockClock.mockNow + 1
        
        let mockItineraryDays = [
            ItineraryDay(itineraryDay: 1, isSeaDay: false, portCode: "MIA", day: "Saturday", dayOfWeek: "S", dayOfMonth: "28", date: todayDate, portName: "Miami"),
            ItineraryDay(itineraryDay: 2, isSeaDay: true, portCode: "", day: "Sunday", dayOfWeek: "S", dayOfMonth: "29", date: tomorrowDate, portName: "")
        ]
        mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(itineraryDays: mockItineraryDays)
        mockClock.mockNow = todayDate
        mockLineUpRepository.mockLineUpEvents = LineUpEvents.sample()
        
        let result = try await useCase.execute(startDateTime: todayDate)

        XCTAssertEqual(result.events.count, mockLineUpRepository.mockLineUpEvents.count)
    }
}
