//
//  MockSetPinEventNotificationService.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 23.7.25.
//

import Foundation
@testable import Virgin_Voyages

class MockSetPinEventNotificationService: SetPinEventNotificationServiceProtocol {
    
    var notifyCalled = false
    var notificationEvent: SetPinNotification?

    func notify(_ event: SetPinNotification) {
        notifyCalled = true
        notificationEvent = event
    }
}
