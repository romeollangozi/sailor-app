//
//  CheckInkEventNotification.swift
//  Virgin Voyages
//
//  Created by Pajtim on 17.4.25.
//

import Foundation

enum CheckInkEventNotification: Hashable {
    case checkInHasChanged
}

class CheckInStatusEventNotificationService: DomainNotificationService<CheckInkEventNotification> {
    static let shared = CheckInStatusEventNotificationService()
}
