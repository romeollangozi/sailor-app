//
//  ReservationStatusEventNotificationService.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 2.4.25.
//

import Foundation

enum ReservationStatusEventNotification: Hashable {
    case newReservationReceived
}

class ReservationStatusEventNotificationService: DomainNotificationService<ReservationStatusEventNotification> {
    static let shared = ReservationStatusEventNotificationService()
}
