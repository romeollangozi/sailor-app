//
//  LineUpScreenViewModelEventHandlingTests.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.7.25.
//

import XCTest
@testable import Virgin_Voyages

class LineUpScreenViewModelEventHandlingTests: XCTestCase {

	var sut: LineUpScreenViewModel!
	var mockBookingEventsNotificationService: MockBookingEventsNotificationServiceForTesting!

	override func setUp() {
		super.setUp()
		mockBookingEventsNotificationService = MockBookingEventsNotificationServiceForTesting()

		sut = LineUpScreenViewModel(
			bookingEventsNotificationService: mockBookingEventsNotificationService
		)
	}

	override func tearDown() {
		sut = nil
		mockBookingEventsNotificationService = nil
		super.tearDown()
	}

	// MARK: - startObservingEvents Tests

	func test_startObservingEvents_shouldCallListenWithCorrectKey() {
		// When
		sut.startObservingEvents()

		// Then
		XCTAssertTrue(mockBookingEventsNotificationService.listenCalled)
		XCTAssertEqual(mockBookingEventsNotificationService.listenKey, "LineUpScreenViewModel")
	}

	func test_startObservingEvents_shouldProvideEventHandler() {
		// When
		sut.startObservingEvents()

		// Then
		XCTAssertNotNil(mockBookingEventsNotificationService.listenHandler)
	}

	// MARK: - stopObservingEvents Tests

	func test_stopObservingEvents_shouldCallStopListeningWithCorrectKey() {
		// When
		sut.stopObservingEvents()

		// Then
		XCTAssertTrue(mockBookingEventsNotificationService.stopListeningCalled)
		XCTAssertEqual(mockBookingEventsNotificationService.stopListeningKey, "LineUpScreenViewModel")
	}

	// MARK: - handleEvent Tests

	func test_handleEvent_withUserDidMakeABooking_shouldCallOnReAppear() {
		// Given
		var onReAppearCalled = false
		let mockSut = MockLineUpScreenViewModel()
		mockSut.onReAppearHandler = {
			onReAppearCalled = true
		}

		let event = BookingEventNotification.userDidMakeABooking(activityCode: "testActivity", activitySlotCode: "testSlot")

		// When
		mockSut.handleEvent(event)

		// Then
		XCTAssertTrue(onReAppearCalled)
	}

	func test_handleEvent_withOtherEvents_shouldNotCallOnReAppear() {
		// Given
		var onReAppearCalled = false
		let mockSut = MockLineUpScreenViewModel()
		mockSut.onReAppearHandler = {
			onReAppearCalled = true
		}

		let otherEvent = BookingEventNotification.userDidUpdateABooking(activityCode: "testActivity", activitySlotCode: "testSlot", appointmentId: "testBooking")

		// When
		mockSut.handleEvent(otherEvent)

		// Then
		XCTAssertFalse(onReAppearCalled)
	}
}
