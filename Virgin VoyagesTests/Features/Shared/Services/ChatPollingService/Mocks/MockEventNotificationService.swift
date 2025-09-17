//
//  MockEventNotificationService.swift
//  Virgin Voyages
//
//  Created by TX on 5.8.25.
//

import XCTest
@testable import Virgin_Voyages

class MockChatThreadEventsNotificationService: ChatThreadEventsNotificationService {
    var publishedEvents: [ChatThreadEventNotification] = []

    override func publish(_ event: ChatThreadEventNotification) {
        publishedEvents.append(event)
    }
}
