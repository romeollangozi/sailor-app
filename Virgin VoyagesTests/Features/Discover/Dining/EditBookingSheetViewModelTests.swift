////
////  EditBookingSheetViewModelTests.swift
////  Virgin Voyages
////
////  Created by Kreshnik Balani on 10.6.25.
////
//
//import XCTest
//@testable import Virgin_Voyages
//
//final class EditBookingSheetViewModelTests: XCTestCase {
//	private var mockUpdateBookingSlotUseCase: MockUpdateBookingSlotUseCase!
//	private var mockCancelBookingSlotUseCase: MockCancelBookingSlotUseCase!
//	private var mockGetEateryConflictsUseCase: MockGetEateryConflictsUseCase!
//	private var mockSwapBookingSlotUseCase: MockSwapBookingSlotUseCase!
//	private var mockGetMySailorsUseCase: MockGetMySailorsUseCase!
//	private var mockGetEateriesSlotsUseCase: MockGetEateriesSlotsUseCase!
//	private var mockGetItineraryDatesUseCase: MockGetItineraryDatesUseCase!
//	private var mockFriendsEventsNotificationService: MockFriendsEventsNotificationService!
//	
//	override func setUp() {
//		super.setUp()
//		
//		mockUpdateBookingSlotUseCase = MockUpdateBookingSlotUseCase()
//		mockGetEateryConflictsUseCase = MockGetEateryConflictsUseCase()
//		mockSwapBookingSlotUseCase = MockSwapBookingSlotUseCase()
//		mockGetMySailorsUseCase = MockGetMySailorsUseCase()
//		mockGetEateriesSlotsUseCase = MockGetEateriesSlotsUseCase()
//		mockCancelBookingSlotUseCase = MockCancelBookingSlotUseCase()
//		mockGetItineraryDatesUseCase = MockGetItineraryDatesUseCase()
//		mockFriendsEventsNotificationService = MockFriendsEventsNotificationService()
//	}
//	
//	override func tearDown() {
//		mockUpdateBookingSlotUseCase = nil
//		mockGetEateryConflictsUseCase = nil
//		mockSwapBookingSlotUseCase = nil
//		mockGetMySailorsUseCase = nil
//		mockGetEateriesSlotsUseCase = nil
//		mockCancelBookingSlotUseCase = nil
//		mockGetItineraryDatesUseCase = nil
//		mockFriendsEventsNotificationService = nil
//		
//		super.tearDown()
//	}
//	
//	private func createViewModel(initialSlotId: String = "initialSlotId",
//								 initialSlotDate: Date = Date(),
//								 externalId: String = "externalId",
//								 venueId: String = "venueId",
//								 initialSailorsIds: [String] = [],
//								 appointmentLinkId: String = "appointmentLinkId",
//								 mealPeriod: MealPeriod = .dinner,
//								 eateryName: String = "Test Eatery",
//								 isWithinCancellationWindow: Bool = false) -> EditEateryBookingSheetViewModelProtocol {
//		
//		return EditBookingSheetViewModel(initialSlotId: initialSlotId,
//										 initialSlotDate: initialSlotDate,
//										 externalId: externalId,
//										 venueId: venueId,
//										 initialSailorsIds: initialSailorsIds,
//										 appointmentLinkId: appointmentLinkId,
//										 mealPeriod: mealPeriod,
//										 eateryName: eateryName,
//										 isWithinCancellationWindow: isWithinCancellationWindow,
//										 eateriesSlotsUseCase: mockGetEateriesSlotsUseCase,
//										 updateBookingSlotUseCase: mockUpdateBookingSlotUseCase,
//										 cancelBookingSlotUseCase: mockCancelBookingSlotUseCase,
//										 mySailorsUseCase: mockGetMySailorsUseCase,
//										 itineraryDatesUseCase: mockGetItineraryDatesUseCase,
//										 friendsEventsNotificationService: mockFriendsEventsNotificationService
//		
//		)
//	}
//	
//	func testCancelAppointmentSuccess() async {
//		mockCancelBookingSlotUseCase.mockResponse = CancelBookingSlotModel.successSample()
//		
//		let viewModel = createViewModel()
//		
//		let actual = await viewModel.cancelAppointment(guests: 1)
//		
//		XCTAssertTrue(actual)
//		XCTAssertFalse(viewModel.isCancelBookSlotLoading)
//	}
//	
//	func testCancelAppointmentFailure() async {
//		let failed = CancelBookingSlotModel.failedSample()
//		mockCancelBookingSlotUseCase.mockResponse = failed
//		
//		let viewModel = createViewModel()
//		
//		let actual = await viewModel.cancelAppointment(guests: 1)
//		
//		XCTAssertFalse(actual)
//		XCTAssertFalse(viewModel.isCancelBookSlotLoading)
//		XCTAssertEqual(failed.error?.title, viewModel.cancelErrorMessage)
//	}
//	
//	func testCancelAppointmentFailureDueToUnhandledException() async {
//		mockCancelBookingSlotUseCase.shouldThrowError = true
//		
//		let viewModel = createViewModel()
//		
//		let actual = await viewModel.cancelAppointment(guests: 1)
//		
//		XCTAssertFalse(actual)
//		XCTAssertFalse(viewModel.isCancelBookSlotLoading)
//		XCTAssertEqual(viewModel.cancelErrorMessage, "Sorry sailor, it looks like we had a glitch in the matrix. please try again")
//	}
//	
//	func testOnUpdateBookSlotClickWhenSlotIsNotPresentShouldNotUpdate() async {
//		let viewModel = createViewModel()
//		
//		viewModel.onUpdateBookSlotClick()
//		
//		XCTAssertFalse(mockUpdateBookingSlotUseCase.isCalled)
//	}
//	
//	func testOnUpdateBookSlotClickShouldUpdate() async {
//		let slots = Slot.sample()
//		mockGetEateriesSlotsUseCase.result = EateriesSlots(
//			restaurants: [.sample().copy(slots: [slots])]
//		)
//		mockUpdateBookingSlotUseCase.mockResponse = UpdateBookingSlotModel.successSample()
//		
//		let viewModel = createViewModel(initialSlotId: slots.id)
//		
//		executeAndWaitForAsyncOperation {
//			viewModel.onAppear()
//		}
//		
//		executeAndWaitForAsyncOperation {
//			viewModel.onUpdateBookSlotClick()
//		}
//		
//		XCTAssertTrue(viewModel.isBookingCompleted)
//		XCTAssertNil(viewModel.bookSlotErrorMessage)
//		XCTAssertEqual(viewModel.screenState, .content)
//	}
//	
//	func testOnUpdateBookSlotClickFailure() async {
//		let slots = Slot.sample()
//		mockGetEateriesSlotsUseCase.result = EateriesSlots(
//			restaurants: [.sample().copy(slots: [slots])]
//		)
//		mockUpdateBookingSlotUseCase.mockResponse = UpdateBookingSlotModel.failedSample()
//		
//		let viewModel = createViewModel(initialSlotId: slots.id)
//		
//		executeAndWaitForAsyncOperation {
//			viewModel.onAppear()
//		}
//		
//		executeAndWaitForAsyncOperation {
//			viewModel.onUpdateBookSlotClick()
//		}
//		
//		XCTAssertFalse(viewModel.isBookingCompleted)
//		XCTAssertNotNil(viewModel.bookSlotErrorMessage)
//		XCTAssertEqual(viewModel.screenState, .content)
//	}
//	
//	func testOnUpdateBookSlotClickFailureDueToUnhandledException() async {
//		let slots = Slot.sample()
//		mockGetEateriesSlotsUseCase.result = EateriesSlots(
//			restaurants: [.sample().copy(slots: [slots])]
//		)
//		mockUpdateBookingSlotUseCase.shouldThrowError = true
//		
//		let viewModel = createViewModel(initialSlotId: slots.id)
//		
//		executeAndWaitForAsyncOperation {
//			viewModel.onAppear()
//		}
//		
//		executeAndWaitForAsyncOperation {
//			viewModel.onUpdateBookSlotClick()
//		}
//		
//		XCTAssertFalse(viewModel.isBookingCompleted)
//		XCTAssertEqual(viewModel.bookSlotErrorMessage, "Sorry sailor, it looks like we had a glitch in the matrix. please try again")
//		XCTAssertEqual(viewModel.screenState, .content)
//	}
//}
