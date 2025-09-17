//
//  PushNotificationsEventNotificationService.swift
//  Virgin Voyages
//
//  Created by TX on 3.7.25.
//


enum PushNotificationsEventNotification: Hashable {
    case deviceTokenHasbeenUpdated(token: String)
}

class PushNotificationsEventNotificationService: DomainNotificationService<PushNotificationsEventNotification> {
    static let shared = PushNotificationsEventNotificationService()
}
