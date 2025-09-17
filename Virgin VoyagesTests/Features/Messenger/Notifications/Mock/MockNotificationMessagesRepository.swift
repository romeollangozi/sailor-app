//
//  MockNotificationMessagesRepository.swift
//  Virgin VoyagesTests
//
//  Created by TX on 27.11.24.
//

import Foundation
@testable import Virgin_Voyages

// Mock NotificationMessagesRepositoryProtocol
class MockNotificationMessagesRepository: NotificationMessagesRepositoryProtocol {
	
    var unreadMessagesResult: Result<[NotificationMessage], VVDomainError>?
    var readMessagesResult: Result<[NotificationMessage], VVDomainError>?

    var shouldReturnError = false
    var shouldReturnSuccess = true
    
    func getAllUnreadMessages(startingFrom page: Int, voyageNumber: String) async -> Result<[NotificationMessage], VVDomainError> {
        return unreadMessagesResult ?? .success([])
    }
    
    func getAllReadMessages(startingFrom page: Int, voyageNumber: String) async -> Result<[NotificationMessage], VVDomainError> {
        return readMessagesResult ?? .success([])
    }
    
    func markNotificationsAsRead(notificationIds: [String]) async -> Bool {
        if shouldReturnError {
            return false
        }
        return shouldReturnSuccess
    }
	
	func getAllNotifications(voyageNumber: String, page: Int) async throws -> Virgin_Voyages.Notifications? {
		return nil
	}
}
