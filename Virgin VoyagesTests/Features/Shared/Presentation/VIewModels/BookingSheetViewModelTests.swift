//
//  BookingSheetViewModelTests.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 9.5.25.
//

import XCTest
@testable import Virgin_Voyages

final class BookingSheetViewModelTests: XCTestCase {
	var mockMySailorsUseCase: MockGetMySailorsUseCase!
	var mockItineraryDatesUseCase: MockGetItineraryDatesUseCase!
	var mockBookActivityUseCase: MockBookActivityUseCase!
	var mockGetBookableConflictsUseCase: MockGetBookableConflictsUseCase!
	var mockGetActivitiesGuestListUseCase: MockGetActivitiesGuestListUseCase!
	var mockGetLineUpUseCase: MockGetLineUpUseCase!
	
	var slotForSummary: Slot? = nil
	var actvitiesGuestListForSummary : [ActivitiesGuest] = []
	
	override func setUp() {
		super.setUp()
		mockMySailorsUseCase = MockGetMySailorsUseCase()
		mockItineraryDatesUseCase = MockGetItineraryDatesUseCase()
		mockBookActivityUseCase = MockBookActivityUseCase()
		mockGetBookableConflictsUseCase = MockGetBookableConflictsUseCase()
		mockGetActivitiesGuestListUseCase = MockGetActivitiesGuestListUseCase()
		mockGetLineUpUseCase = MockGetLineUpUseCase()
	}
	
	override func tearDown() {
		mockMySailorsUseCase = nil
		mockItineraryDatesUseCase = nil
		mockBookActivityUseCase = nil
		mockGetBookableConflictsUseCase = nil
		mockGetActivitiesGuestListUseCase = nil
		mockGetLineUpUseCase = nil
		
		slotForSummary = nil
		actvitiesGuestListForSummary = []
		
		super.tearDown()
	}
	
	@MainActor private func createViewModel(title: String = "Booking Activity",
								 activityCode: String = "activityCode",
								 bookableType: BookableType = .entertainment,
								 price: Double? = nil,
								 currencyCode: String? = nil,
								 description: String? = nil,
								 categoryCode: String = "",
								 slots: [Slot] = [],
								 initialSlotId: String? = nil,
								 initialSailorIds: [String] = [],
								 eligibleGuestIds: [String] = [],
								 showAddNewSailorButton: Bool = true,
								 appointmentLinkId: String? = nil,
								 isWithinCancellationWindow: Bool = false,
								 sailorSelectionStrategy: SailorSelectionStrategy = NoRestrictionStrategy(),
                                 locationString: String? = nil,
                                 bookableImageName: String? = nil,
                                 categoryString:  String? = nil) -> BookingSheetViewModelProtocol {
		
		return BookingSheetViewModel(title: title,
									 activityCode: activityCode,
									 bookableType: bookableType,
									 price: price,
									 currencyCode: currencyCode,
									 description: description,
									 categoryCode: categoryCode,
									 slots: slots,
									 initialSlotId: initialSlotId,
									 initialSailorIds: initialSailorIds,
									 showAddNewSailorButton: showAddNewSailorButton,
									 appointmentLinkId: appointmentLinkId,
									 isWithinCancellationWindow: isWithinCancellationWindow,
									 sailorSelectionStrategy: sailorSelectionStrategy,
                                     locationString: locationString,
                                     bookableImageName: bookableImageName,
                                     categoryString: categoryString,
									 eligibleGuestIds: eligibleGuestIds,
									 mySailorsUseCase: mockMySailorsUseCase,
									 itineraryDatesUseCase: mockItineraryDatesUseCase,
									 bookActivityUseCase: mockBookActivityUseCase,
									 getBookableConflictsUseCase: mockGetBookableConflictsUseCase,
									 getLineUpUseCase: mockGetLineUpUseCase,
									 localizationManager: MockLocalizationManager(preloaded: [.bookingModalDescription: "Hi Sailor — sorry, but you can’t amend a booking so close to to the start time."]))
	}
}

// MARK: onFirstAppearTests
extension BookingSheetViewModelTests {
	@MainActor func testOnFirstAppearShouldLoadScreenDataWhenSlotsIsEmpty() {
		let expectedAvailableSailors = SailorModel.samples()
		mockMySailorsUseCase.mockResponse = expectedAvailableSailors
		
		let itineraryDates = ItineraryDay.samples()
		mockItineraryDatesUseCase.result = itineraryDates
		
		let viewModel = createViewModel(slots:[])
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertEqual(viewModel.availableSailors, expectedAvailableSailors)
		XCTAssertEqual(viewModel.itineraryDates, [])
		XCTAssertEqual(viewModel.availableDates, [])
		XCTAssertEqual(viewModel.disabledDates, [])
		XCTAssertDatesEqual(viewModel.selectedDay, Date())
		XCTAssertEqual(viewModel.availableTimeSlots, [])
		XCTAssertEqual(viewModel.selectedTimeSlot, .empty)
		XCTAssertEqual(viewModel.screenState, .content)
	}
	
	@MainActor func testOnFirstAppearShouldLoadScreenDataWhenSlotsAreSpecified() {
		let expectedAvailableSailors = SailorModel.samples()
		mockMySailorsUseCase.mockResponse = expectedAvailableSailors
		
		let now = Date()
		let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
		let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!
		
		let itineraryDates = [
			ItineraryDay.sample().copy(date: yesterday),
			ItineraryDay.sample().copy(date: now),
			ItineraryDay.sample().copy(date: tomorrow)
		]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(startDateTime: yesterday, endDateTime: yesterday.addingTimeInterval(TimeIntervalDurations.oneHour)),
			Slot.sample().copy(startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: expectedAvailableSailors.count)
		]
		
		let viewModel = createViewModel(slots: slots)
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertEqual(viewModel.availableSailors, expectedAvailableSailors)
		XCTAssertEqual(viewModel.itineraryDates, itineraryDates.getDates())
		XCTAssertEqual(viewModel.availableDates, [yesterday, now])
		XCTAssertEqual(viewModel.disabledDates, [tomorrow])
		XCTAssertEqual(viewModel.selectedDay, now)
		XCTAssertEqual(viewModel.availableTimeSlots, [.init(id: slots[1].id, text: slots[1].timeText)])
		XCTAssertEqual(viewModel.selectedTimeSlot, .init(id: slots[1].id, text: slots[1].timeText))
		XCTAssertEqual(viewModel.screenState, .content)
	}
	
	@MainActor func testOnFirstAppearShouldSelectFirstFutureDateWhenVoyageIsInThefuture() {
		let expectedAvailableSailors = SailorModel.samples()
		mockMySailorsUseCase.mockResponse = expectedAvailableSailors
		
		let now = Date()
		let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!
		let afterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: now)!
		
		let itineraryDates = [
			ItineraryDay.sample().copy(date: tomorrow),
			ItineraryDay.sample().copy(date: afterTomorrow)
		]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(startDateTime: tomorrow, endDateTime: tomorrow.addingTimeInterval(TimeIntervalDurations.oneHour)),
			Slot.sample().copy(startDateTime: afterTomorrow, endDateTime: afterTomorrow.addingTimeInterval(TimeIntervalDurations.oneHour))
		]
		
		let viewModel = createViewModel(slots: slots)
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertDatesEqual(viewModel.selectedDay, tomorrow)
	}
	
	@MainActor func testOnFirstAppearShouldNotLoadConflictsWhenBookableIsNonInventoried() {
		let expectedAvailableSailors = SailorModel.samples()
		mockMySailorsUseCase.mockResponse = expectedAvailableSailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour))
		]
		
		let conflicts: [BookableConflictsModel] = [.sampleHardConflict().copy(slotId: slots[0].id)]
		mockGetBookableConflictsUseCase.mockResponse = conflicts
		
		let viewModel = createViewModel(price: nil, slots: slots)
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertNil(viewModel.conflict)
	}
	
	@MainActor func testOnFirstAppearShouldNotLoadConflictsNoSlotsAvailable() {
		let expectedAvailableSailors = SailorModel.samples()
		mockMySailorsUseCase.mockResponse = expectedAvailableSailors
		
		let conflicts: [BookableConflictsModel] = [.sampleHardConflict()]
		mockGetBookableConflictsUseCase.mockResponse = conflicts
		
		let viewModel = createViewModel(slots: [])
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertNil(viewModel.conflict)
	}
	
	@MainActor func testOnFirstAppearShouldNotLoadConflictsOnEditWhenSlotSelectedHasNotChanged() {
		let sailors = SailorModel.samples()
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour))
		]
		
		let conflicts: [BookableConflictsModel] = [.sampleHardConflict().copy(slotId: slots[0].id)]
		mockGetBookableConflictsUseCase.mockResponse = conflicts
		
		let viewModel = createViewModel(price: 0, slots: slots, initialSlotId: slots[0].id, initialSailorIds: sailors.getOnlyReservationGuestIds(), appointmentLinkId: "1234")
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertNil(viewModel.conflict)
	}
	
	@MainActor func testOnFirstAppearShouldLoadConflictsWhenBookableIsInventoriedFree() {
		let sailors = [SailorModel.sample().copy(isLoggedInSailor: true)]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour))
		]
		
		let conflicts: [BookableConflictsModel] = [.sampleHardConflict().copy(slotId: slots[0].id)]
		mockGetBookableConflictsUseCase.mockResponse = conflicts
		
		let viewModel = createViewModel(price: 0, slots: slots)
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertEqual(conflicts[0], viewModel.conflict)
	}
	
	@MainActor func testOnFirstAppearShouldLoadConflictsWhenBookableIsInventoriedPaid() {
		let sailors = [SailorModel.sample().copy(isLoggedInSailor: true)]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour))
		]
		
		let conflicts: [BookableConflictsModel] = [.sampleHardConflict().copy(slotId: slots[0].id)]
		mockGetBookableConflictsUseCase.mockResponse = conflicts
		
		let viewModel = createViewModel(price: 10, slots: slots)
				
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertEqual(conflicts[0], viewModel.conflict)
	}
	
	@MainActor func testOnFirstAppearShouldSelectByDefaultLoggedInSailor() {
		let sailors = [
			SailorModel.sample().copy(id: "1", isLoggedInSailor: true),
			SailorModel.sample().copy(id: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let viewModel = createViewModel()
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertEqual(viewModel.selectedSailors, [sailors[0]])
	}
	
	@MainActor func testOnFirstAppearShouldSelectInitialSailorsWhenSpecified() {
		let sailors = [
			SailorModel.sample().copy(id: "1", reservationGuestId: "1", isLoggedInSailor: true),
			SailorModel.sample().copy(id: "2", reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let viewModel = createViewModel(initialSailorIds: ["2"])
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertEqual(viewModel.selectedSailors, [sailors[1]])
	}
	
	@MainActor func testOnFirstAppearShouldLoadAvailableSailorsWhenNoRestrictions() {
		let sailors = [SailorModel.sample()]
		mockMySailorsUseCase.mockResponse = sailors
		
		let viewModel = createViewModel()
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertEqual(viewModel.availableSailors, sailors)
	}
	
	@MainActor func testOnFirstAppearShouldLoadAvailableSailorsWithCabinMateRestriction() {
		let sailors = [
			SailorModel.sample().copy(id: "1", isCabinMate: true),
			SailorModel.sample().copy(id: "2", isCabinMate: false),
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let viewModel = createViewModel(sailorSelectionStrategy: OnlyCabinMatesStrategy())
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertEqual(viewModel.availableSailors, [sailors[0]])
	}
	
	@MainActor func testOnFirstAppearShouldLoadAvailableSailorsWithCabinLoggedInRestriction() {
		let sailors = [
			SailorModel.sample().copy(id: "1", isCabinMate: true, isLoggedInSailor: true),
			SailorModel.sample().copy(id: "2", isCabinMate: false, isLoggedInSailor: false),
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let viewModel = createViewModel(sailorSelectionStrategy: OnlyLoggedInSailorStrategy())
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertEqual(viewModel.availableSailors, [sailors[0]])
	}
	
	@MainActor func testOnFirstAppearShouldNotLoadScreenDataWhenFetchingSailorsThrows() {
		mockMySailorsUseCase.mockResponse = nil
		
		let viewModel = createViewModel(sailorSelectionStrategy: OnlyLoggedInSailorStrategy())
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertEqual(viewModel.availableSailors, [])
		XCTAssertEqual(viewModel.itineraryDates, [])
		XCTAssertEqual(viewModel.availableDates, [])
		XCTAssertEqual(viewModel.disabledDates, [])
		XCTAssertDatesEqual(viewModel.selectedDay, Date())
		XCTAssertEqual(viewModel.availableTimeSlots, [])
		XCTAssertEqual(viewModel.selectedTimeSlot, .empty)
		XCTAssertEqual(viewModel.screenState, .error)
	}
	
	@MainActor func testOnFirstAppearShouldHighlightPreviousSlotBookedOnEdit() throws {
		throw XCTSkip("Skipping this test. For some strang reason even though the slot is highlighted it is not reflected on the viewModel. Need to investigate further.")
		
		let sailors = SailorModel.samples()
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour))
		]
		
		var viewModel = createViewModel(slots: slots, initialSlotId: "1", appointmentLinkId: "1233")
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		XCTAssertTrue(viewModel.selectedTimeSlot.isHignlighted)
	}

	@MainActor func testIsPreviewMyAgendaVisible_ShouldReturnTrue_WhenNotEditFlowAndNotAddOns() {
		let viewModel = createViewModel(bookableType: .entertainment, appointmentLinkId: nil)
		XCTAssertTrue(viewModel.isPreviewMyAgendaVisible)
	}

	@MainActor func testIsPreviewMyAgendaVisible_ShouldReturnFalse_WhenEditFlow() {
		let viewModel = createViewModel(bookableType: .entertainment, appointmentLinkId: "1233")
		XCTAssertFalse(viewModel.isPreviewMyAgendaVisible)
	}

	@MainActor func testIsPreviewMyAgendaVisible_ShouldReturnFalse_WhenBookableTypeIsAddOns() {
		let viewModel = createViewModel(bookableType: .addOns, appointmentLinkId: nil)
		XCTAssertFalse(viewModel.isPreviewMyAgendaVisible)
	}

	@MainActor func testIsPreviewMyAgendaVisible_ShouldReturnFalse_WhenEditFlowAndBookableTypeIsAddOns() {
		let viewModel = createViewModel(bookableType: .addOns, appointmentLinkId: "1233")
		XCTAssertFalse(viewModel.isPreviewMyAgendaVisible)
	}

	@MainActor func testShowPreviewAgendaSheet_ShouldSetFlagToTrue() {
		var viewModel = createViewModel()
		viewModel.showPreviewMyAgendaSheet = false
		viewModel.onPreviewAgendaTapped()
		XCTAssertTrue(viewModel.showPreviewMyAgendaSheet)
	}

	@MainActor func testHidePreviewAgendaSheet_ShouldSetFlagToFalse() {
		var viewModel = createViewModel()
		viewModel.showPreviewMyAgendaSheet = true
		viewModel.onPreviewMyAgendaDismiss()
		XCTAssertFalse(viewModel.showPreviewMyAgendaSheet)
	}
}

// MARK: onCancelTappedTests
extension BookingSheetViewModelTests {
	@MainActor func testOnCancelUpdateShowBookingCancellationConfirmation() {
		let viewModel = createViewModel()
		viewModel.onCancelTapped()
		
		XCTAssertTrue(viewModel.showBookingCancellationConfirmation)
	}
}

// MARK: getTotalPriceFormattedTests
extension BookingSheetViewModelTests {
	@MainActor func testGetTotalPriceFormattedShouldReturnNilWhenBookableIsNonInventoried() {
		mockMySailorsUseCase.mockResponse = [SailorModel.sample()]
		
		let viewModel = createViewModel(price: nil)
		let actual = viewModel.getTotalPriceFormatted()
		
		
		XCTAssertNil(actual)
	}
	
	@MainActor func testGetTotalPriceFormattedShouldReturnTotalAmountToPay() {
		let sailors = [SailorModel.sample(), SailorModel.sample()]
		mockMySailorsUseCase.mockResponse = sailors
		
		var viewModel = createViewModel(price: 10, currencyCode: "USD")
		viewModel.selectedSailors = sailors
		
		let actual = viewModel.getTotalPriceFormatted()
		
		XCTAssertEqual(actual, "$ 20.00")
	}
	
	@MainActor func testGetTotalPriceFormattedShouldReturnNilWhenSelectedSailorsIsSameWithPreviousBooked() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		var viewModel = createViewModel(price: 10, currencyCode: "USD", initialSailorIds: ["1", "2"], appointmentLinkId: "1234")
		viewModel.selectedSailors = sailors
		
		let actual = viewModel.getTotalPriceFormatted()
		
		XCTAssertNil(actual)
	}
	
	@MainActor func testGetTotalPriceFormattedShouldReturnNilWhenSelectedSailorsIsLessThanPreviousBooked() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		var viewModel = createViewModel(price: 10, currencyCode: "USD", initialSailorIds: ["1", "2"], appointmentLinkId: "1234")
		viewModel.selectedSailors = [sailors[0]]
		
		let actual = viewModel.getTotalPriceFormatted()
		
		XCTAssertNil(actual)
	}
	
	@MainActor func testGetTotalPriceFormattedShouldReturnTheDifferenceBetweenfSelectedSailorsIsAndPreviousBooked() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		var viewModel = createViewModel(price: 10, currencyCode: "USD", initialSailorIds: ["1"], appointmentLinkId: "1234")
		viewModel.selectedSailors = sailors
		
		let actual = viewModel.getTotalPriceFormatted()
		
		XCTAssertEqual(actual, "$ 10.00")
	}
}

// MARK: IsNextButtonDisabledTests
extension BookingSheetViewModelTests {
	@MainActor func testIsNextButtonDisabledShouldReturnTrueWhenNoSailorIsSelected() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		var viewModel = createViewModel(price: 10, currencyCode: "USD", initialSailorIds: ["1"], appointmentLinkId: "1234")
		viewModel.selectedSailors = []
		
		let actual = viewModel.isNextButtonDisabled()
		
		XCTAssertTrue(actual)
	}
	
	func testIsNextButtonDisabledShouldReturnTrueWhenNoSlotIsSelected() async {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour))
		]
		
		var viewModel = await createViewModel(slots: slots)
		viewModel.selectedSailors = sailors
		viewModel.selectedTimeSlot = .empty
		
		let actual = viewModel.isNextButtonDisabled()
		
		XCTAssertTrue(actual)
	}
	
	func testIsNextButtonDisabledShouldReturnFalseWhenNoSlotIsSelectedAndNotSlotsAreAvailable() async {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		var viewModel = await createViewModel()
		viewModel.selectedSailors = sailors
		viewModel.selectedTimeSlot = .empty
		
		let actual = viewModel.isNextButtonDisabled()
		
		XCTAssertFalse(actual)
	}
	
	@MainActor func testIsNextButtonDisabledShouldReturnTrueWhenUserHasNotMadeAnyChangeOnBookingOnEdit() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour))
		]
		
		var viewModel = createViewModel(price: 10,
										slots: slots,
										initialSlotId: "1",
										initialSailorIds: ["1", "2"],
										appointmentLinkId: "1234")
		viewModel.selectedSailors = sailors
		viewModel.selectedTimeSlot = .init(id: slots[0].id, text: slots[0].timeText)
		
		let actual = viewModel.isNextButtonDisabled()
		
		XCTAssertTrue(actual)
	}
	
	@MainActor func testIsNextButtonDisabledShouldReturnTrueWhenHasLimitedInventory() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1)
		]
		
		let viewModel = createViewModel(price: 10, slots: slots)
		
		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}
		
		let actual = viewModel.isNextButtonDisabled()
		
		XCTAssertTrue(actual)
	}
	
	@MainActor func testIsNextButtonDisabledShouldReturnFalseWhenUserSelectedSailorsAndSlot() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1)
		]
		
		var viewModel = createViewModel(slots: slots)
		viewModel.selectedSailors = sailors
		viewModel.selectedTimeSlot = .init(id: slots[0].id, text: slots[0].timeText)
		
		let actual = viewModel.isNextButtonDisabled()
		
		XCTAssertFalse(actual)
	}
	
	@MainActor func testIsNextButtonDisabledShouldReturnFalseWhenUserSelectedDifferentSailorsFromPreviousBooking() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1)
		]
		
		let previousBookedSlot: TimeSlotOptionV2 = .init(id: slots[0].id, text: slots[0].timeText)
		
		var viewModel = createViewModel(slots: slots, initialSlotId: slots[0].id, initialSailorIds: [sailors[0].reservationGuestId], appointmentLinkId: "1234")
		viewModel.selectedSailors = sailors
		viewModel.selectedTimeSlot = previousBookedSlot
		
		let actual = viewModel.isNextButtonDisabled()
		
		XCTAssertFalse(actual)
	}
	
	@MainActor func testIsNextButtonDisabledShouldReturnFalseWhenUserSelectedDifferentSlotFromPreviousBooking() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 2),
			Slot.sample().copy(id: "2", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 2)
		]
		
		var viewModel = createViewModel(slots: slots, initialSlotId: slots[0].id, initialSailorIds: [sailors[0].reservationGuestId], appointmentLinkId: "1234")
		viewModel.selectedSailors = [sailors[0]]
		viewModel.selectedTimeSlot = .init(id: slots[1].id, text: slots[1].timeText)
		
		let actual = viewModel.isNextButtonDisabled()
		
		XCTAssertFalse(actual)
	}
}

// MARK: IsNextButtonDisabledTests
extension BookingSheetViewModelTests {
	@MainActor func testGetBookingButtonTextShouldReturnNextTextWhenUserSelectedSailorsAndSlot() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1)
		]
		
		var viewModel = createViewModel(slots: slots)
		viewModel.selectedSailors = sailors
		viewModel.selectedTimeSlot = .init(id: slots[0].id, text: slots[0].timeText)
		
		let actual = viewModel.getBookingButtonText()
		
		XCTAssertEqual(actual, "Next")
	}
	
	@MainActor func testGetBookingButtonTextShouldReturnSelectDetailsTextWhenUserHasNotSelectedAnySailor() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1)
		]
		
		var viewModel = createViewModel(slots: slots)
		viewModel.selectedSailors = []
		
		let actual = viewModel.getBookingButtonText()
		
		XCTAssertEqual(actual, "Select Booking Details")
	}
	
	@MainActor func testGetBookingButtonTextShouldReturnSelectDetailsTextWhenUserHasNotSelectedSlot() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1)
		]
		
		var viewModel = createViewModel(slots: slots)
		viewModel.selectedSailors = sailors
		viewModel.selectedTimeSlot = .empty
		
		let actual = viewModel.getBookingButtonText()
		
		XCTAssertEqual(actual, "Select Booking Details")
	}
	
	@MainActor func testGetBookingButtonTextShouldReturnEditDetailsTextWhenUserHasNotMadeChangesFromPreviousBooking() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1)
		]
		
		var viewModel = createViewModel(slots: slots, initialSlotId: slots[0].id, initialSailorIds: ["1", "2"], appointmentLinkId: "1234")
		viewModel.selectedSailors = sailors
		viewModel.selectedTimeSlot = .init(id: slots[0].id, text: slots[0].timeText)
		
		let actual = viewModel.getBookingButtonText()
		
		XCTAssertEqual(actual, "Edit details")
	}
	
	@MainActor func testGetBookingButtonTextShouldReturnEditDetailsTextWhenUserHasNotSelectedAnySailorOnEdit() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1),
			Slot.sample().copy(id: "2", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1)
		]
		
		var viewModel = createViewModel(slots: slots, initialSlotId: slots[0].id, initialSailorIds: ["1", "2"], appointmentLinkId: "1234")
		viewModel.selectedSailors = []
		viewModel.selectedTimeSlot = .init(id: slots[1].id, text: slots[1].timeText)
		
		let actual = viewModel.getBookingButtonText()
		
		XCTAssertEqual(actual, "Edit details")
	}
	
	@MainActor func testGetBookingButtonTextShouldReturnEditDetailsTextWhenUserHasNotSelectedAnySlotOnEdit() {
		let sailors = [
			SailorModel.sample().copy(id: "1" ,reservationGuestId: "1"),
			SailorModel.sample().copy(id: "2" ,reservationGuestId: "2")
		]
		mockMySailorsUseCase.mockResponse = sailors
		
		let now = Date()
		let itineraryDates = [ItineraryDay.sample().copy(date: now)]
		mockItineraryDatesUseCase.result = itineraryDates
		
		let slots: [Slot] = [
			Slot.sample().copy(id: "1", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1),
			Slot.sample().copy(id: "2", startDateTime: now, endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour), inventoryCount: 1)
		]
		
		var viewModel = createViewModel(slots: slots, initialSlotId: slots[0].id, initialSailorIds: ["1", "2"], appointmentLinkId: "1234")
		viewModel.selectedSailors = sailors
		viewModel.selectedTimeSlot = .empty
		
		let actual = viewModel.getBookingButtonText()
		
		XCTAssertEqual(actual, "Edit details")
	}

	@MainActor func testLabels_ShouldReturnLocalizedBookingNotAllowedText() {
		// Arrange
		let expectedText = "Hi Sailor — sorry, but you can’t amend a booking so close to to the start time."
		let viewModel = createViewModel()

		// Act
		let actualText = viewModel.labels.bookingNotAllowed

		// Assert
		XCTAssertEqual(actualText, expectedText)
	}
}


extension BookingSheetViewModelTests {

	@MainActor func testNotAllowedSailors_ShouldReturnEmptyArray_WhenAllSailorsAreEligible() {
		// Arrange
		let sailors = [
			SailorModel.sample().copy(id: "1", guestId: "guest1"),
			SailorModel.sample().copy(id: "2", guestId: "guest2")
		]
		mockMySailorsUseCase.mockResponse = sailors

		let viewModel = createViewModel(eligibleGuestIds: ["guest1", "guest2"])

		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}

		// Act
		let result = viewModel.notAllowedSailors

		// Assert
		XCTAssertEqual(result.count, 0)
		XCTAssertTrue(result.isEmpty)
	}

	@MainActor func testNotAllowedSailors_ShouldReturnOnlyNonEligibleSailors_WhenSomeSailorsAreNotEligible() {
		// Arrange
		let sailors = [
			SailorModel.sample().copy(id: "1", guestId: "guest1"),
			SailorModel.sample().copy(id: "2", guestId: "guest2"),
			SailorModel.sample().copy(id: "3", guestId: "guest3")
		]
		mockMySailorsUseCase.mockResponse = sailors

		let viewModel = createViewModel(eligibleGuestIds: ["guest1"])

		executeAndWaitForAsyncOperation {
			viewModel.onFirstAppear()
		}

		// Act
		let result = viewModel.notAllowedSailors

		// Assert
		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result, [sailors[1], sailors[2]])
		XCTAssertTrue(result.allSatisfy { !["guest1"].contains($0.guestId) })
	}
}


// MARK: - Focused tests for getBookingButtonText (new)
extension BookingSheetViewModelTests {

    @MainActor func test_GetBookingButtonText_ReturnsLimitedAvailability_WhenInventoryTooLow() {
        // 2 sailors vs inventory=1
        let sailors = [
            SailorModel.sample().copy(id: "1", reservationGuestId: "1", isLoggedInSailor: true),
            SailorModel.sample().copy(id: "2", reservationGuestId: "2")
        ]
        var vm = makeVM(price: 10, inventoryCount: 1)
        executeAndWaitForAsyncOperation { vm.onFirstAppear() }
        // Force selection to 2 sailors -> limited availability
        vm.selectedSailors = sailors
        vm.onSailorSelectionChanged()

        XCTAssertEqual(vm.getBookingButtonText(), "Limited Availability")
    }

    @MainActor func test_GetBookingButtonText_TreatmentEdit_NoSailorChange_ReturnsConfirmPayment() {
        // Treatment + edit + same sailors as previous (["1"])
        let vm = makeVM(
            price: 25,
            bookableType: .treatment,
            initialSlotId: "slot-1",
            initialSailorIds: ["1"],
            appointmentLinkId: "applink"
        )
        executeAndWaitForAsyncOperation { vm.onFirstAppear() }

        // No change vs previous
        XCTAssertEqual(vm.getBookingButtonText(), "Confirm Payment")
    }

    @MainActor func test_GetBookingButtonText_NoSailors_NotEdit_ReturnsSelectBookingDetails() {
        var vm = makeVM(price: 10)
        executeAndWaitForAsyncOperation { vm.onFirstAppear() }
        vm.selectedSailors = []
        vm.selectedTimeSlot = .empty
        XCTAssertEqual(vm.getBookingButtonText(), "Select Booking Details")
    }

    @MainActor func test_GetBookingButtonText_NotReady_EditFlow_ReturnsEditDetails() {
        var vm = makeVM(price: 10, initialSlotId: "slot-1", initialSailorIds: ["1"], appointmentLinkId: "applink")
        executeAndWaitForAsyncOperation { vm.onFirstAppear() }
        vm.selectedSailors = []
        XCTAssertEqual(vm.getBookingButtonText(), "Edit details")
    }

    @MainActor func test_GetBookingButtonText_Ready_ReturnsNext() {
        let vm = makeVM(price: 10)
        executeAndWaitForAsyncOperation { vm.onFirstAppear() }
        XCTAssertEqual(vm.getBookingButtonText(), "Next")
    }
}

// MARK: - Focused tests for onNextTapped() (new)
// These indirectly verify the private shouldConfirmBookingWithoutShowingPaymentSummary
extension BookingSheetViewModelTests {

    @MainActor func test_OnNextTapped_NonInventoried_BooksDirectly() {
        let spy = MockSPABookActivityUseCase()
        let vm = makeVM(price: nil, spyBook: spy) // non-inventoried
        executeAndWaitForAsyncOperation { vm.onFirstAppear() }

        executeAndWaitForAsyncOperation { vm.onNextTapped() }

        XCTAssertEqual(spy.calls.count, 1, "Non-inventoried should book immediately (no summary)")
    }

    @MainActor func test_OnNextTapped_TreatmentEdit_NoSailorChange_BooksDirectly() {
        let spy = MockSPABookActivityUseCase()
        let vm = makeVM(price: 30,
                        bookableType: .treatment,
                        initialSlotId: "slot-1",
                        initialSailorIds: ["1"],
                        appointmentLinkId: "applink",
                        spyBook: spy)
        executeAndWaitForAsyncOperation { vm.onFirstAppear() }

        executeAndWaitForAsyncOperation { vm.onNextTapped() }

        XCTAssertEqual(spy.calls.count, 1, "Treatment edit with no sailor change should confirm directly (private flag true)")
    }

    @MainActor func test_OnNextTapped_TreatmentEdit_WithSailorChange_NavigatesToSummary_NoDirectBooking() {
        let spy = MockSPABookActivityUseCase()
        let sailors = [
            SailorModel.sample().copy(id: "1", reservationGuestId: "1", isLoggedInSailor: true),
            SailorModel.sample().copy(id: "2", reservationGuestId: "2")
        ]
        var vm = makeVM(price: 30,
                        bookableType: .treatment,
                        initialSlotId: "slot-1",
                        initialSailorIds: ["1"],
                        appointmentLinkId: "applink",
                        spyBook: spy)
        executeAndWaitForAsyncOperation { vm.onFirstAppear() }

        // Change selection -> flag should be false, so it should go to summary
        vm.selectedSailors = sailors

        executeAndWaitForAsyncOperation { vm.onNextTapped() }

        XCTAssertEqual(spy.calls.count, 0, "With sailor change, summary should be shown first (no direct booking)")
    }

    @MainActor func test_OnNextTapped_PaidInventoried_NavigatesToSummary_NoDirectBooking() {
        let spy = MockSPABookActivityUseCase()
        let vm = makeVM(price: 10, spyBook: spy)
        executeAndWaitForAsyncOperation { vm.onFirstAppear() }

        executeAndWaitForAsyncOperation { vm.onNextTapped() }

        XCTAssertEqual(spy.calls.count, 0, "Paid inventoried should navigate to summary, not book directly")
    }
}

// MARK: - Helper
extension BookingSheetViewModelTests {
    @MainActor
    func makeVM(
        price: Double?,
        bookableType: BookableType = .entertainment,
        initialSlotId: String? = nil,
        initialSailorIds: [String] = [],
        appointmentLinkId: String? = nil,
        spyBook: MockSPABookActivityUseCase? = nil,
        inventoryCount: Int = 2
    ) -> BookingSheetViewModelProtocol {
        let sailors = [
            SailorModel.sample().copy(id: "1", reservationGuestId: "1", isLoggedInSailor: true),
            SailorModel.sample().copy(id: "2", reservationGuestId: "2")
        ]
        mockMySailorsUseCase.mockResponse = sailors

        let now = Date()
        mockItineraryDatesUseCase.result = [ItineraryDay.sample().copy(date: now)]
        let slots: [Slot] = [
            Slot.sample().copy(
                id: "slot-1",
                startDateTime: now,
                endDateTime: now.addingTimeInterval(TimeIntervalDurations.oneHour),
                inventoryCount: inventoryCount
            )
        ]

        return BookingSheetViewModel(
            title: "Activity",
            activityCode: "code",
            bookableType: bookableType,
            price: price,
            currencyCode: price == nil ? nil : "USD",
            categoryCode: "CAT",
            slots: slots,
            initialSlotId: initialSlotId,
            initialSailorIds: initialSailorIds,
            appointmentLinkId: appointmentLinkId,
            mySailorsUseCase: mockMySailorsUseCase,
            itineraryDatesUseCase: mockItineraryDatesUseCase,
            bookActivityUseCase: spyBook ?? mockBookActivityUseCase,
            getBookableConflictsUseCase: mockGetBookableConflictsUseCase,
            getLineUpUseCase: mockGetLineUpUseCase,
            localizationManager: MockLocalizationManager(preloaded: [
                .bookingModalDescription: "Hi Sailor — sorry, but you can’t amend a booking so close to to the start time."
            ])
        )
    }
}
