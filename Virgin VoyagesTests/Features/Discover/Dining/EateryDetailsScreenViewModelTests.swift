//
//  EateryDetailsScreenViewModelTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 14.4.25.
//

import XCTest
@testable import Virgin_Voyages

final class EateryDetailsScreenViewModelTests: XCTestCase {
	private var mockGetEateryDetailsUseCase: MockGetEateryDetailsUseCase!
	private var mockEateriesSlotsUseCase: MockGetEateriesSlotsUseCase!
	private var mockMySailorsUseCase: MockGetMySailorsUseCase!
	private var mockItineraryDatesUseCase: MockGetItineraryDatesUseCase!
    private var mockFetchHtmlService: MockHTMLFetcherService!
    private var viewModel: EateryDetailsScreenViewModel!

	override func setUp() {
		super.setUp()
		
		mockGetEateryDetailsUseCase = MockGetEateryDetailsUseCase()
		mockEateriesSlotsUseCase = MockGetEateriesSlotsUseCase()
		mockMySailorsUseCase = MockGetMySailorsUseCase()
		mockItineraryDatesUseCase = MockGetItineraryDatesUseCase()
        mockFetchHtmlService = MockHTMLFetcherService()

		viewModel = EateryDetailsScreenViewModel(slug: "",
												 filter: nil,
												 eateryDetailsUseCase: mockGetEateryDetailsUseCase,
												 eateriesSlotsUseCase: mockEateriesSlotsUseCase,
												 mySailorsUseCase: mockMySailorsUseCase,
												 itineraryDatesUseCase: mockItineraryDatesUseCase,
                                                 htmlFetcherService: mockFetchHtmlService)
	}
	
	override func tearDown() {
		mockGetEateryDetailsUseCase = nil
		mockEateriesSlotsUseCase = nil
		mockMySailorsUseCase = nil
        mockFetchHtmlService = nil
		viewModel = nil
		super.tearDown()
	}
	
	func testOnAppearLoadsScreenData() {
		let expectedEateryDetails = EateryDetailsModel.sample().copy(isBookable: true)
		mockGetEateryDetailsUseCase.result = expectedEateryDetails
		
		let expectedAvailableSailors = SailorModel.samples()
		mockMySailorsUseCase.mockResponse = expectedAvailableSailors
		
		executeAndWaitForAsyncOperation {
			self.viewModel.onAppear()
		}
		
		XCTAssertEqual(viewModel.eateryDetails, expectedEateryDetails)
		XCTAssertEqual(viewModel.availableSailors, expectedAvailableSailors)
		XCTAssertEqual(viewModel.screenState, .content)
	}
	
	
	func testOnRefreshLoadsScreenData()  {
		let expectedEateryDetails = EateryDetailsModel.sample().copy(isBookable: true)
		mockGetEateryDetailsUseCase.result = expectedEateryDetails
		
		let expectedAvailableSailors = SailorModel.samples()
		mockMySailorsUseCase.mockResponse = expectedAvailableSailors
		
		executeAndWaitForAsyncOperation {
			self.viewModel.onRefresh()
		}
		
		XCTAssertEqual(viewModel.eateryDetails, expectedEateryDetails)
		XCTAssertEqual(viewModel.availableSailors, expectedAvailableSailors)
		XCTAssertEqual(viewModel.screenState, .content)
	}

    func testIsMenuClickableWithValidPdfUrl() {
        let expectedEateryDetails = EateryDetailsModel.sample()
        viewModel.eateryDetails = expectedEateryDetails

        XCTAssertTrue(viewModel.isMenuClickable)
    }

    func testIsMenuClickableWithEmptyPdfUrl() {
        let expectedEateryDetails = EateryDetailsModel.empty()
        viewModel.eateryDetails = expectedEateryDetails

        XCTAssertFalse(viewModel.isMenuClickable)
    }

    func testOnEditEateryWithSlotsButtonClick() {
        let eatery = EateriesSlots.Restaurant.sample().copy(appointment: AppointmentItem.sample())
        viewModel.onEditEateryWithSlotsButtonClick(eatery: eatery)

        XCTAssertEqual(viewModel.showEditSlotBookSheet, true)
    }

    func testLoadEditorialBlocks() async {
        let expectedEateryDetails = EateryDetailsModel.sample()
        viewModel.eateryDetails = expectedEateryDetails
        mockFetchHtmlService.htmlByURL = [
            expectedEateryDetails.editorialBlocks.first!: "<html>Block1</html>"
        ]

        await viewModel.loadEditorialBlocks()

        XCTAssertEqual(viewModel.editorialBlocks.count, 1)
        XCTAssertEqual(viewModel.editorialBlocks[0].html, "<html>Block1</html>")
        XCTAssertEqual(mockFetchHtmlService.calledURLs, expectedEateryDetails.editorialBlocks)
    }
}

