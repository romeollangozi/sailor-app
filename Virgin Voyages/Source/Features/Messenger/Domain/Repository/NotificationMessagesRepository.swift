//
//  MessengerUseCase.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 18.10.24.
//

import Foundation

protocol NotificationMessagesRepositoryProtocol {
    func getAllUnreadMessages(startingFrom page: Int, voyageNumber: String) async -> Result<[NotificationMessage], VVDomainError>
    func getAllReadMessages(startingFrom page: Int, voyageNumber: String) async -> Result<[NotificationMessage], VVDomainError>
    func markNotificationsAsRead(notificationIds: [String]) async -> Bool
	func getAllNotifications(voyageNumber: String, page: Int) async throws -> Notifications?
}

class NotificationMessagesRepository: NotificationMessagesRepositoryProtocol {
	
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.create()) {
        self.networkService = networkService
    }
    
    func getAllUnreadMessages(startingFrom page: Int, voyageNumber: String) async -> Result<[NotificationMessage], VVDomainError> {
        var allMessages: [NotificationMessage] = []
        var currentPage = page // Start from the given page
        
        while true {
            let fetchUnreadMessagesResponse = await networkService.fetchUnreadMessages(pageNumber: currentPage, voyageNumber: voyageNumber)
            
            if let networkError = fetchUnreadMessagesResponse.error {
                let domainError = NetworkToVVDomainErrorMapper.map(from: networkError)
                return .failure(domainError)
            }
            
            if let apiResult = fetchUnreadMessagesResponse.response {
                guard let unreadAPIMessages = apiResult.unreadNotification else { break }
                
                // Map API messages to domain messages and append
                var filteredOutNotificationsCount = 0
                let messages: [NotificationMessage] = unreadAPIMessages.compactMap {
                    if $0.Notification_Title.value.isEmpty {
                        filteredOutNotificationsCount += 1
                        return nil
                    }
                    return NotificationMessage.mapFromAPIDTO(response: $0, isRead: false)
                }
                allMessages.append(contentsOf: messages)
                let allMessagesCount = allMessages.count + filteredOutNotificationsCount
                
                // Check if there are more items to fetch
                if let numOfItemsOnServer = apiResult.Length,
                   allMessagesCount < numOfItemsOnServer {
                    currentPage += 1 // Move to the next page
                } else {
                    break // No more items to fetch
                }
            } else {
                break // The response is invalid
            }
        }
        
        return .success(allMessages) // Return all accumulated unread messages
    }
    
    func getAllReadMessages(startingFrom page: Int, voyageNumber: String) async -> Result<[NotificationMessage], VVDomainError> {
        var allMessages: [NotificationMessage] = []
        var currentPage = page // Start from the given page
        
        while true {
            let fetchReadMessagesResponse = await networkService.fetchReadMessages(pageNumber: currentPage, voyageNumber: voyageNumber)
            
            if let networkError = fetchReadMessagesResponse.error {
                let domainError = NetworkToVVDomainErrorMapper.map(from: networkError)
                return .failure(domainError)
            }
            
            if let apiResult = fetchReadMessagesResponse.response {
                guard let readAPIMessages = apiResult.readNotification else { break }
                
                // Map API messages to domain messages and append
                var filteredOutNotificationsCount = 0
                let messages: [NotificationMessage] = readAPIMessages.compactMap {
                    if $0.Notification_Title.value.isEmpty {
                        filteredOutNotificationsCount += 1
                        return nil
                    }
                    return NotificationMessage.mapFromAPIDTO(response: $0, isRead: true)
                }
                allMessages.append(contentsOf: messages)
                let allMessagesCount = allMessages.count + filteredOutNotificationsCount                
                
                // Check if there are more items to fetch
                if let numOfItemsOnServer = apiResult.Length,
                   allMessagesCount < numOfItemsOnServer {
                    currentPage += 1 // Move to the next page
                } else {
                    break // No more items to fetch
                }
            } else {
                break // The response is invalid
            }
        }
        
        return .success(allMessages)
    }
    
    func markNotificationsAsRead(notificationIds: [String]) async -> Bool {
        let now = Date.unixTimeNow()
        let input = MarkNotificationsAsReadRequestBody(Read_Time: now, NotificationIDs: notificationIds)
        
        do {
            let results =  try await networkService.markNotificationsAsReadRequest(input: input)
            guard results.error == nil else { return false }
            return true
        } catch {
            return false
        }
    }
	
	func getAllNotifications(voyageNumber: String, page: Int) async throws -> Notifications? {
		let response = try await networkService.getNotifications(voyageNumber: voyageNumber, page: page)
		
		return response?.toDomain()
	}
}

class MockNotificationMessagesRepository: NotificationMessagesRepositoryProtocol {
    func getAllUnreadMessages(startingFrom page: Int, voyageNumber: String) async -> Result<[NotificationMessage], VVDomainError> {
        return .success([
            .init(id: "1", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pretium dictum volutpat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur id fringilla nibh.", type: .actionNotifications, title: "Mock notification 1", readTime: Date.now, sentAt: Date.now, isRead: false, notificationType: "travelparty.excursion.cancelled", notificationData: "{\"activityCode\":\"BIMAUT00001\",\"currentDay\":3,\"bookingLinkId\":\"dc1f6362-6822-42e5-b9ac-24c35f36d449\",\"isBookingProcess\":false,\"appointmentId\":\"bac2f315-c178-4d79-bae1-49c5e12ac2b5\",\"currentDate\":[2025,5,21],\"categoryCode\":\"PA\"}"),
            .init(id: "2", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", type: .actionNotifications, title: "Mock notification 2", readTime: Date.now, sentAt: Date.now, isRead: false, notificationType: "travelparty.excursion.cancelled", notificationData: "{\"activityCode\":\"BIMAUT00001\",\"currentDay\":3,\"bookingLinkId\":\"dc1f6362-6822-42e5-b9ac-24c35f36d449\",\"isBookingProcess\":false,\"appointmentId\":\"bac2f315-c178-4d79-bae1-49c5e12ac2b5\",\"currentDate\":[2025,5,21],\"categoryCode\":\"PA\"}")
        ])
    }
    
    func getAllReadMessages(startingFrom page: Int, voyageNumber: String) async -> Result<[NotificationMessage], VVDomainError> {
        return .success([
            .init(id: "1", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pretium dictum volutpat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur id fringilla nibh.", type: .actionNotifications, title: "Mock notification 1", readTime: Date.now, sentAt: Date.now, isRead: true, notificationType: "travelparty.excursion.cancelled", notificationData: "{\"activityCode\":\"BIMAUT00001\",\"currentDay\":3,\"bookingLinkId\":\"dc1f6362-6822-42e5-b9ac-24c35f36d449\",\"isBookingProcess\":false,\"appointmentId\":\"bac2f315-c178-4d79-bae1-49c5e12ac2b5\",\"currentDate\":[2025,5,21],\"categoryCode\":\"PA\"}")
        ])
    }
    
    func markNotificationsAsRead(notificationIds: [String]) async -> Bool {
        return true
    }
	
	func getAllNotifications(voyageNumber: String, page: Int) async throws -> Notifications? {
		return nil
	}
}
