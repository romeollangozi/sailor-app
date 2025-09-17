//
//  EaterySlotBookViewModelTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.4.25.
//

import XCTest
@testable import Virgin_Voyages

final class EaterySlotBookViewModelTests: XCTestCase {
	private var mockBookSlotUseCase: MockBookSlotUseCase!
	private var mockGetEateryConflictsUseCase: MockGetEateryConflictsUseCase!
	private var mockSwapBookingSlotUseCase: MockSwapBookingSlotUseCase!
	private var mockGetMySailorsUseCase: MockGetMySailorsUseCase!
	
	override func setUp() {
		super.setUp()
		
		mockBookSlotUseCase = MockBookSlotUseCase()
		mockGetEateryConflictsUseCase = MockGetEateryConflictsUseCase()
		mockSwapBookingSlotUseCase = MockSwapBookingSlotUseCase()
		mockGetMySailorsUseCase = MockGetMySailorsUseCase()
	}
	
	override func tearDown() {
		mockBookSlotUseCase = nil
		mockGetEateryConflictsUseCase = nil
		mockSwapBookingSlotUseCase = nil
		mockGetMySailorsUseCase = nil
		
		super.tearDown()
	}
	
	private func createViewModel(title: String = "Booking Dining",
								 activityCode: String =  "activityCode",
								 slot: Slot = .sample(),
								 mealPeriod: MealPeriod = .dinner,
								 selectedSailors: [SailorModel] = [],
								 disclaimer: String? = nil) -> EaterySlotBookViewModelProtocol {
		
		return EaterySlotBookViewModel(title: title,
									   activityCode: activityCode,
									   slot: slot,
									   mealPeriod: mealPeriod,
									   selectedSailors: selectedSailors,
									   disclaimer: disclaimer,
									   bookSlotUseCase: mockBookSlotUseCase,
									   getEateryConflicsUseCase: mockGetEateryConflictsUseCase,
									   swapBookingSlotUseCase: mockSwapBookingSlotUseCase,
									   mySailorsUseCase: mockGetMySailorsUseCase)
	}
	
	func testOnAppearLoadsData() async {
		mockGetEateryConflictsUseCase.mockResponse = EateryConflictsModel.none
		let sailors = SailorModel.samples()
		mockGetMySailorsUseCase.mockResponse = sailors
		
		let viewModel = createViewModel(selectedSailors: sailors)
		
		await viewModel.onAppear()
		
		XCTAssertEqual(viewModel.screenState, .content)
		XCTAssertEqual(viewModel.availableSailors, sailors)
		XCTAssertEqual(viewModel.conflictData, EateryConflictsModel.none)
	}
	
	func testOnRefreshReloadsData() async {
		mockGetEateryConflictsUseCase.mockResponse = EateryConflictsModel.none
		let sailors = SailorModel.samples()
		mockGetMySailorsUseCase.mockResponse = sailors
		
		let viewModel = createViewModel(selectedSailors: sailors)
		
		await viewModel.onAppear()
		
		XCTAssertEqual(viewModel.screenState, .content)
		XCTAssertEqual(viewModel.availableSailors, sailors)
		XCTAssertEqual(viewModel.conflictData, EateryConflictsModel.none)
	}
	
	func testOnConfirmSwapClick() async {
		let viewModel = createViewModel(selectedSailors: SailorModel.samples())
		
		viewModel.onConfirmSwapClick()

		XCTAssertTrue(viewModel.isSwapping)
	}
	
	func testOnBookClickCreatesBookingSuccess() async {
		mockBookSlotUseCase.mockResponse = BookSlot.successSample()

		let viewModel = createViewModel(selectedSailors: SailorModel.samples())
		
		await viewModel.onBookClick()

		XCTAssertTrue(viewModel.isBookingCompleted)
		XCTAssertNil(viewModel.bookSlotErrorMessage)
		XCTAssertEqual(viewModel.screenState, .content)
	}
	
	func testOnBookClickBookingFails() async {
		mockBookSlotUseCase.mockResponse = BookSlot.failedSample()

		let viewModel = createViewModel(selectedSailors: SailorModel.samples())
		
		await viewModel.onBookClick()

		XCTAssertFalse(viewModel.isBookingCompleted)
		XCTAssertNotNil(viewModel.bookSlotErrorMessage)
		XCTAssertEqual(viewModel.screenState, .content)
	}
	
	func testOnBookClickBookingFailsDueToUnhandledException() async {
		mockBookSlotUseCase.shouldThrowError = true

		let viewModel = createViewModel(selectedSailors: SailorModel.samples())
		
		await viewModel.onBookClick()

		XCTAssertFalse(viewModel.isBookingCompleted)
		XCTAssertEqual(viewModel.bookSlotErrorMessage, "Sorry sailor, it looks like we had a glitch in the matrix. please try again")
		XCTAssertEqual(viewModel.screenState, .content)
	}
	
	func testOnBookClickDoesNotCreateBookingWhenDisclaimer() async {
		let viewModel = createViewModel(selectedSailors: SailorModel.samples(), disclaimer: "Disclamer")

		await viewModel.onBookClick()

		XCTAssertTrue(viewModel.showDisclaimerErroMessage)
	}
	
	func testOnBookClickSwapsBooking() async {
		mockSwapBookingSlotUseCase.mockResponse = SwapBookingSlotModel.successSample()
		
		let viewModel = createViewModel(selectedSailors: SailorModel.samples())
		viewModel.onConfirmSwapClick()
		
		await viewModel.onBookClick()

		XCTAssertTrue(viewModel.isSwapCompleted)
		XCTAssertNil(viewModel.bookSlotErrorMessage)
		XCTAssertEqual(viewModel.screenState, .content)
	}
	
	func testOnBookClickSwapFails() async {
		mockSwapBookingSlotUseCase.mockResponse = SwapBookingSlotModel.failedSample()
		
		let viewModel = createViewModel(selectedSailors: SailorModel.samples())
		viewModel.onConfirmSwapClick()
		
		await viewModel.onBookClick()

		XCTAssertFalse(viewModel.isSwapCompleted)
		XCTAssertNotNil(viewModel.bookSlotErrorMessage)
		XCTAssertEqual(viewModel.screenState, .content)
	}
	
	func testOnBookClickSwapFailsDueToUnhandledException() async {
		mockSwapBookingSlotUseCase.shouldThrowError = true

		let viewModel = createViewModel(selectedSailors: SailorModel.samples())
		
		await viewModel.onBookClick()

		XCTAssertFalse(viewModel.isSwapCompleted)
		XCTAssertEqual(viewModel.bookSlotErrorMessage, "Sorry sailor, it looks like we had a glitch in the matrix. please try again")
		XCTAssertEqual(viewModel.screenState, .content)
	}

    func testOnBookClickDoesNotCompleteSwapingWhenDisclaimer() async {
        let viewModel = createViewModel(selectedSailors: SailorModel.samples(), disclaimer: "Disclamer")

        viewModel.onConfirmSwapClick()
        await viewModel.onBookClick()

        XCTAssertFalse(viewModel.isSwapCompleted)
        XCTAssertTrue(viewModel.showDisclaimerErroMessage)
    }
}
