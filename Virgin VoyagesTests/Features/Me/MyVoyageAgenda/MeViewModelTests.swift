//
//  MeViewModelTests.swift
//  Virgin VoyagesTests
//
//  Created by Darko Trpevski on 29.5.25.
//

import XCTest
@testable import Virgin_Voyages

@MainActor
final class MeViewModelTests: XCTestCase {

	var sut: MeViewModel!

	// MARK: - Mock Dependencies
	var mockGetMyVoyageHeaderUseCase: MockGetMyVoyageHeaderUseCase!
	var mockGetMyVoyageAgendaUseCase: MockGetMyVoyageAgendaUseCase!
	var mockGetMyVoyageAddOnsUseCase: MockGetMyVoyageAddOnsUseCase!
	var mockGetSailingModeUseCase: MockGetSailingModeUseCase!
	var mockGetSailorDateAndTimeUseCase: MockGetSailorDateAndTimeUseCase!
	var mockItineraryDatesUseCase: MeMockGetItineraryDatesUseCase!

	override func setUp() {
		super.setUp()
		mockGetMyVoyageHeaderUseCase = MockGetMyVoyageHeaderUseCase()
		mockGetMyVoyageAgendaUseCase = MockGetMyVoyageAgendaUseCase()
		mockGetMyVoyageAddOnsUseCase = MockGetMyVoyageAddOnsUseCase()
		mockGetSailingModeUseCase = MockGetSailingModeUseCase()
		mockGetSailorDateAndTimeUseCase = MockGetSailorDateAndTimeUseCase()
		mockItineraryDatesUseCase = MeMockGetItineraryDatesUseCase()

		sut = MeViewModel(
			getMyVoyageHeaderUseCase: mockGetMyVoyageHeaderUseCase,
			getMyVoyageAddOnsUseCase: mockGetMyVoyageAddOnsUseCase,
			getMyVoyageAgendaUseCase: mockGetMyVoyageAgendaUseCase,
			getSailingModeUseCase: mockGetSailingModeUseCase,
			getSailorDateAndTimeUseCase: mockGetSailorDateAndTimeUseCase,
			itineraryDatesUseCase: mockItineraryDatesUseCase
		)
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func test_onFirstAppear() {
		mockGetMyVoyageHeaderUseCase.executeResult = .sample()
		mockGetMyVoyageAgendaUseCase.executeResult = .sample()
		mockGetMyVoyageAddOnsUseCase.executeResult = .sample()
		mockGetSailingModeUseCase.executeResult = .preCruise
		mockItineraryDatesUseCase.executeResult = [
			ItineraryDay(itineraryDay: 1, isSeaDay: false, portCode: "MIA", day: "Saturday", dayOfWeek: "S", dayOfMonth: "28", date: ISO8601DateFormatter().date(from: "2024-12-28T00:00:00Z")!, portName: "Miami"),
			ItineraryDay(itineraryDay: 2, isSeaDay: true, portCode: "", day: "Sunday", dayOfWeek: "S", dayOfMonth: "29", date: ISO8601DateFormatter().date(from: "2024-12-29T00:00:00Z")!, portName: ""),
			ItineraryDay(itineraryDay: 3, isSeaDay: false, portCode: "POP", day: "Monday", dayOfWeek: "M", dayOfMonth: "30", date: ISO8601DateFormatter().date(from: "2024-12-30T00:00:00Z")!, portName: "Puerto Plata")
		]
		mockGetSailorDateAndTimeUseCase.executeResult = Date()

		executeAndWaitForAsyncOperation { [self] in
			Task { sut.onFirstAppear() }
		}

		XCTAssertEqual(sut.screenState, .content)
		XCTAssertEqual(sut.myVoyageHeader.name, "Sailor name")
		XCTAssertEqual(sut.sailingMode, .preCruise)
		XCTAssertEqual(sut.myVoyageAddOns.addOns.count, 3)
		XCTAssertEqual(sut.myVoyageAgenda.appointments.count, 3)
	}

	func test_onReAppear() {
		mockGetMyVoyageHeaderUseCase.executeResult = .sample()
		mockGetMyVoyageAgendaUseCase.executeResult = .sample()
		mockGetMyVoyageAddOnsUseCase.executeResult = .sample()
		mockGetSailingModeUseCase.executeResult = .preCruise

		executeAndWaitForAsyncOperation { [self] in
			Task { sut.onReAppear() }
		}

		XCTAssertEqual(mockGetMyVoyageHeaderUseCase.lastUseCacheValue, true)
		XCTAssertEqual(mockGetMyVoyageAgendaUseCase.lastUseCacheValue, false)
		XCTAssertEqual(mockGetMyVoyageAddOnsUseCase.lastUseCacheValue, false)
		XCTAssertEqual(sut.screenState, .content)
	}
    
    func test_navigateToSpecificDate() {
        
        let testDate = ISO8601DateFormatter().date(from: "2024-12-29T00:00:00Z")!

        sut.navigateToSpecificDate(testDate)

        XCTAssertEqual(sut.selectedDate, testDate)
    }

//    func test_resetToCurrentDate() {
//        let sailorDate = ISO8601DateFormatter().date(from: "2024-12-29T10:00:00Z")!
//
//        sut.resetToCurrentDate()
//
//        XCTAssertEqual(sut.selectedDate.timeIntervalSinceReferenceDate, sut.itineraryDays.findItineraryDateOrDefault(for: sailorDate).timeIntervalSinceReferenceDate, accuracy: 0.001)
//    }
    
}
