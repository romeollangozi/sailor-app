//
//  MockBookingEventsNotificationService.swift
//  Virgin VoyagesTests
//
//  Created by Pajtim on 11.7.25.
//

import Foundation
@testable import Virgin_Voyages


final class MockBookingEventsNotificationService: BookingEventsNotificationService {
    var publishedEvents: [BookingEventNotification] = []

    override func publish(_ event: BookingEventNotification) {
        publishedEvents.append(event)
    }
}
