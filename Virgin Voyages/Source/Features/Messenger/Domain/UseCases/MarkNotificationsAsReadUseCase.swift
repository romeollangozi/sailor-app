//
//  MarkNotificationsAsReadUseCase.swift
//  Virgin Voyages
//
//  Created by TX on 26.11.24.
//

import Foundation

protocol MarkNotificationsAsReadUseCaseProtocol {
    func execute(notificationIds: [String]) async -> Bool
}

class MarkNotificationsAsReadUseCase: MarkNotificationsAsReadUseCaseProtocol {
    
    var repository: NotificationMessagesRepositoryProtocol
    
    init(repository: NotificationMessagesRepositoryProtocol = NotificationMessagesRepository()) {
        self.repository = repository
    }
    
    func execute(notificationIds: [String]) async -> Bool {
        await repository.markNotificationsAsRead(notificationIds: notificationIds)
    }
}
