//
//  ASDSDADS.swift
//  Virgin Voyages
//
//  Created by TX on 14.2.25.
//

import Foundation

enum ChatThreadEventNotification: Hashable {
    case newMessageReceived
}

class ChatThreadEventsNotificationService: DomainNotificationService<ChatThreadEventNotification> {
    static let shared = ChatThreadEventsNotificationService()
}

