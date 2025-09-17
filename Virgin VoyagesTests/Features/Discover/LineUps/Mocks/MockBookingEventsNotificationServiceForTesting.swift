//
//  MockBookingEventsNotificationServiceForTesting.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 24.7.25.
//

import XCTest
@testable import Virgin_Voyages

class MockBookingEventsNotificationServiceForTesting: BookingEventsNotificationService {
	var listenCalled = false
	var listenKey: String?
	var listenHandler: ((BookingEventNotification) -> Void)?

	var stopListeningCalled = false
	var stopListeningKey: String?

	override func listen(key: String, using handler: @escaping (BookingEventNotification) -> Void) {
		listenCalled = true
		listenKey = key
		listenHandler = handler
	}

	override func stopListening(key: String) {
		stopListeningCalled = true
		stopListeningKey = key
	}
}
