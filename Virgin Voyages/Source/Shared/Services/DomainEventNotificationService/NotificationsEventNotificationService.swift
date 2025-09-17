//
//  NotificationsEventNotificationService.swift
//  Virgin Voyages
//
//  Created by TX on 25.4.25.
//

enum NotificationsEventNotification: Hashable {
    case shouldUpdateNotificationSection
}

protocol NotificationsEventNotificationServiceProtocol {
    func notify(_ event: NotificationsEventNotification)
}

final class NotificationsEventNotificationService: DomainNotificationService<NotificationsEventNotification> {
    static let shared = NotificationsEventNotificationService()
}

extension NotificationsEventNotificationService: NotificationsEventNotificationServiceProtocol {
    func notify(_ event: NotificationsEventNotification) {
        publish(event)
    }
}
