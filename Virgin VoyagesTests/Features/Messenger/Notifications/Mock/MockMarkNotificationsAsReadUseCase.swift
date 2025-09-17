//
//  MockMarkNotificationsAsReadUseCase.swift
//  Virgin VoyagesTests
//
//  Created by TX on 27.11.24.
//

import XCTest
@testable import Virgin_Voyages

// Mock MarkNotificationsAsReadUseCase
class MockMarkNotificationsAsReadUseCase: MarkNotificationsAsReadUseCaseProtocol {
    
    var repository: NotificationMessagesRepositoryProtocol
    var shouldReturnSuccess = true

    init(repository: NotificationMessagesRepositoryProtocol = MockNotificationMessagesRepository()) {
        self.repository = repository
    }
    
    func execute(notificationIds: [String]) async -> Bool {
        if !shouldReturnSuccess {
            return false
        }
        return await repository.markNotificationsAsRead(notificationIds: notificationIds)
    }
}

