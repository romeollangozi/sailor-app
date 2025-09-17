//
//  EateriesListScreenViewModelTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.4.25.
//

import XCTest
@testable import Virgin_Voyages

final class EateriesListScreenViewModelTests: XCTestCase {
	private var mockEateriesListUseCase: MockGetEateriesListUseCase!
	private var mockEateriesSlotsUseCase: MockGetEateriesSlotsUseCase!
	private var mockMySailorsUseCase: MockGetMySailorsUseCase!
	private var mockItineraryDatesUseCase: MockGetItineraryDatesUseCase!
	private var viewModel: EateriesListScreenViewModel!
	
	override func setUp() {
		super.setUp()
		mockEateriesListUseCase = MockGetEateriesListUseCase()
		mockEateriesSlotsUseCase = MockGetEateriesSlotsUseCase()
		mockMySailorsUseCase = MockGetMySailorsUseCase()
		mockItineraryDatesUseCase = MockGetItineraryDatesUseCase()
		viewModel = EateriesListScreenViewModel(
			eateriesListUseCase: mockEateriesListUseCase,
			eateriesSlotsUseCase: mockEateriesSlotsUseCase,
			mySailorsUseCase: mockMySailorsUseCase,
			itineraryDatesUseCase: mockItineraryDatesUseCase
		)
	}
	
	override func tearDown() {
		mockEateriesListUseCase = nil
		mockEateriesSlotsUseCase = nil
		mockMySailorsUseCase = nil
		mockItineraryDatesUseCase = nil
		viewModel = nil
		super.tearDown()
	}
	
//	func testFirstAppearLoadsScreenData() {
//		let expectedEateriesList = EateriesList.sample()
//		mockEateriesListUseCase.result = expectedEateriesList
//		
//		let expectedEateriesWithSlots = EateriesSlots.sample()
//		mockEateriesSlotsUseCase.result = expectedEateriesWithSlots
//		
//		let expectedAvailableSailors = SailorModel.samples()
//		mockMySailorsUseCase.mockResponse = expectedAvailableSailors
//		
//		let expectedDates = ItineraryDay.samples()
//		mockItineraryDatesUseCase.result = expectedDates
//		
//		executeAndWaitForAsyncOperation {
//			self.viewModel.onFirstAppear()
//		}
//
//		XCTAssertEqual(viewModel.eateriesList, expectedEateriesList)
//		XCTAssertEqual(viewModel.filter.venues.count, expectedEateriesList.bookable.count)
//		
//		XCTAssertEqual(viewModel.eateriesWithSlots, expectedEateriesWithSlots)
//		
//		XCTAssertEqual(viewModel.availableSailors, expectedAvailableSailors)
//		XCTAssertEqual(viewModel.filter.guests, expectedAvailableSailors.onlyCabinMates())
//		
//		XCTAssertEqual(viewModel.screenState, .content)
//		
//		XCTAssertEqual(viewModel.itineraryDates, expectedDates)
//		XCTAssertEqual(viewModel.filter.searchSlotDate, expectedDates.findItineraryDateOrDefault(for: Date()))
//	}
	
	func testOnRefreshLoadsScreenData() {
		let expectedEateriesList = EateriesList.sample()
		mockEateriesListUseCase.result = expectedEateriesList
		
		let expectedEateriesWithSlots = EateriesSlots.sample()
		mockEateriesSlotsUseCase.result = expectedEateriesWithSlots
		
		let expectedAvailableSailors = SailorModel.samples()
		mockMySailorsUseCase.mockResponse = expectedAvailableSailors
		
		let expectedDates = ItineraryDay.samples()
		mockItineraryDatesUseCase.result = expectedDates
		
		executeAndWaitForAsyncOperation {
			self.viewModel.onRefresh()
		}
		
		XCTAssertEqual(viewModel.eateriesList, expectedEateriesList)
		XCTAssertEqual(viewModel.filter.venues.count, expectedEateriesList.bookable.count)
		
		XCTAssertEqual(viewModel.eateriesWithSlots, expectedEateriesWithSlots)
		
		XCTAssertEqual(viewModel.availableSailors, expectedAvailableSailors)
		XCTAssertEqual(viewModel.filter.guests, expectedAvailableSailors.onlyCabinMates())
		
		XCTAssertEqual(viewModel.screenState, .content)
		
		XCTAssertEqual(viewModel.itineraryDates, expectedDates)
		XCTAssertEqual(viewModel.filter.searchSlotDate, expectedDates.findItineraryDateOrDefault(for: Date()))
	}

    func testOnEditEateryWithSlotsButtonClick() {
        let eatery = EateriesSlots.Restaurant.sample().copy(appointment: AppointmentItem.sample())
        viewModel.onEditEateryWithSlotsButtonClick(eatery: eatery)

        XCTAssertEqual(viewModel.showEditSlotBookSheet, true)
    }
}
