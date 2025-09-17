//
//  Untitled.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 9.3.25.
//

import XCTest
@testable import Virgin_Voyages

final class GetMyVoyageAgendaUseCaseTests: XCTestCase {
    private var mockVoyageAgendaRepository: MockMyVoyageAgendaRepository!
    private var mockCurrentSailorManager: MockCurrentSailorManager!
    var mockClock: MockClock!
    private var useCase: GetMyVoyageAgendaUseCase!
    
    override func setUp() {
        super.setUp()
        mockVoyageAgendaRepository = MockMyVoyageAgendaRepository()
        mockCurrentSailorManager = MockCurrentSailorManager()
        mockClock = MockClock()
        useCase = GetMyVoyageAgendaUseCase(
            myVoyageAgendaRepository: mockVoyageAgendaRepository,
            currentSailorManager: mockCurrentSailorManager
        )
    }
    
    override func tearDown() {
        mockVoyageAgendaRepository = nil
        mockCurrentSailorManager = nil
        mockClock = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecuteShouldReturnAgenda() async throws {
        let todayDate = mockClock.mockNow
        let tomorrowDate = mockClock.mockNow + 1
        let mockItineraryDays = [
            ItineraryDay(itineraryDay: 1, isSeaDay: false, portCode: "MIA", day: "Saturday", dayOfWeek: "S", dayOfMonth: "28", date: todayDate, portName: "Miami"),
            ItineraryDay(itineraryDay: 2, isSeaDay: true, portCode: "", day: "Sunday", dayOfWeek: "S", dayOfMonth: "29", date: tomorrowDate, portName: "")
        ]
        let mockMyVoyageAgenda = MyVoyageAgenda.sample()
        
        mockCurrentSailorManager.lastSailor = CurrentSailor.sample().copy(itineraryDays: mockItineraryDays)
        mockClock.mockNow = todayDate
        mockVoyageAgendaRepository.myVoyageAgenda = mockMyVoyageAgenda
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.title, mockMyVoyageAgenda.title)
        XCTAssertEqual(result.appointments.count, mockMyVoyageAgenda.appointments.count)
        XCTAssertEqual(result.emptyStateText, mockMyVoyageAgenda.emptyStateText)
        XCTAssertEqual(result.emptyStatePictogramUrl, mockMyVoyageAgenda.emptyStatePictogramUrl)

    }

    func testExecute_Error() async {
        mockVoyageAgendaRepository.shouldThrowError = true
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error but did not receive one.")
        } catch {
            XCTAssertTrue(error is VVDomainError)
        }
    }
}
