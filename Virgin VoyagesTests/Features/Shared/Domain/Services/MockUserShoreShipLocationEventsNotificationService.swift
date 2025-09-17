//
//  MockUserShoreShipLocationEventsNotificationService.swift
//  Virgin Voyages
//
//  Created by TX on 6.8.25.
//

import Foundation
@testable import Virgin_Voyages


final class MockUserShoreShipLocationEventsNotificationService: UserShoreShipLocationEventsNotificationService {
    private(set) var publishedEvents: [UserShoreShipLocationEventNotification] = []

    override func publish(_ event: UserShoreShipLocationEventNotification) {
        publishedEvents.append(event)
    }
}
