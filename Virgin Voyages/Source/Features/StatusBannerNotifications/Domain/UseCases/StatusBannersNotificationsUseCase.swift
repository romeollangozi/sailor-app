//
//  StatusBannersNotificationsUseCase.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/29/25.
//

import Foundation

protocol StatusBannersNotificationsUseCaseProtocol {
    func execute() async throws -> (display: [StatusBannersNotifications.StatusBannersNotificationItem],
                                    delete: [StatusBannersNotifications.StatusBannersNotificationItem])
}

final class StatusBannersNotificationsUseCase: StatusBannersNotificationsUseCaseProtocol {
    
    private let statusBannersNotificationsRepository: StatusBannersNotificationsRepositoryProtocol
    private let currentSailorManager: CurrentSailorManagerProtocol
    private let notificationJSONDecoder: NotificationJSONDecoderProtocol
    
    init(statusBannersNotificationsRepository: StatusBannersNotificationsRepositoryProtocol = StatusBannersNotificationsRepository(),
         currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
         notificationJSONDecoder: NotificationJSONDecoderProtocol = NotificationJSONDecoder()) {
        self.statusBannersNotificationsRepository = statusBannersNotificationsRepository
        self.currentSailorManager = currentSailorManager
        self.notificationJSONDecoder = notificationJSONDecoder
    }
    
    func execute() async throws -> (display: [StatusBannersNotifications.StatusBannersNotificationItem],
                                    delete: [StatusBannersNotifications.StatusBannersNotificationItem]) {
        
        guard let currentSailor = currentSailorManager.getCurrentSailor() else {
            throw VVDomainError.unauthorized
        }
        
        guard let statusBannersNotifications = try await statusBannersNotificationsRepository.getStatusBannersNotifications(voyageNumber: currentSailor.voyageNumber) else {
            throw VVDomainError.genericError
        }
        
        return separateNotificationsByOrderId(from: statusBannersNotifications.items)
    }
    
    private func separateNotificationsByOrderId(
            from notifications: [StatusBannersNotifications.StatusBannersNotificationItem]
        ) -> (display: [StatusBannersNotifications.StatusBannersNotificationItem],
              delete: [StatusBannersNotifications.StatusBannersNotificationItem]) {
        
        // Sort by createdAt descending
        let sortedNotifications = notifications.sorted { $0.createdAt > $1.createdAt }
        
        var seenOrderIds = Set<String>()
        var displayNotifications: [StatusBannersNotifications.StatusBannersNotificationItem] = []
        var deleteNotifications: [StatusBannersNotifications.StatusBannersNotificationItem] = []
        
        for notification in sortedNotifications {
            
            if let orderId = getOrderId(data: notification.data) {
                
                if seenOrderIds.insert(orderId).inserted {
                    
                    displayNotifications.append(notification)
                } else {
                    
                    deleteNotifications.append(notification)
                }
                
            }
            
        }
        
        return (display: displayNotifications, delete: deleteNotifications)
    }
    
    private func getOrderId(data: String) -> String? {
        
        if let shakeForChampagneNotificationData: ShakeForChampagneNotificationData = notificationJSONDecoder.decodeNotificationData(data, as: ShakeForChampagneNotificationData.self) {
            
            let shakeForChampagneNotification = shakeForChampagneNotificationData.toDomain()
            
            return shakeForChampagneNotification.ORDER_ID
        }
        
        return nil
    }
    
}
