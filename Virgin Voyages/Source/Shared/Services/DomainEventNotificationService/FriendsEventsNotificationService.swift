//
//  FriendsEventsNotificationService.swift
//  Virgin Voyages
//
//  Created by TX on 3.2.25.
//

import Foundation

enum FriendsEventNotification: Hashable {
    case friendAdded
    case friendRemoved
}

class FriendsEventsNotificationService: DomainNotificationService<FriendsEventNotification> {
    static let shared = FriendsEventsNotificationService()
}

