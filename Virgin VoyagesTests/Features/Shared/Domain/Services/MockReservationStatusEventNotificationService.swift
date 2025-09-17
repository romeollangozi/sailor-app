//
//  MockReservationStatusEventNotificationService.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 7.4.25.
//

import Foundation
@testable import Virgin_Voyages

final class MockReservationStatusEventNotificationService: ReservationStatusEventNotificationService {
    private(set) var publishedEvents: [ReservationStatusEventNotification] = []

    override func publish(_ event: ReservationStatusEventNotification) {
        publishedEvents.append(event)
    }
}
