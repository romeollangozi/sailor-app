//
//  NotificationMessageCardModel.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 28.10.24.
//

import Foundation

struct NotificationMessageCardModel: Identifiable, Hashable, Equatable {
    var id: String = UUID().uuidString

    let title: String
    let description: String
    let notificationsCountText: String
    let readTime: String
    var isRead: Bool
    var showReadUnreadIndicator: Bool
    var sentAt: String
    var type: NotificationType
    var notificationType: String
    var notificationData: String
    
    init(notificationId: String, title: String,
         description: String,
         notificationsCountText: String,
         readTime: String,
         isRead: Bool,
         showReadUnreadIndicator: Bool,
         sentAt: String = "",
         type: NotificationType,
         notificationType: String,
         notificationData: String) {
        
        self.id = notificationId
        self.title = title
        self.description = description
        self.notificationsCountText = notificationsCountText
        self.readTime = readTime
        self.isRead = isRead
        self.showReadUnreadIndicator = showReadUnreadIndicator
        self.sentAt = sentAt
        self.type = type
        self.notificationType = notificationType
        self.notificationData = notificationData
    }
    
    // Empty CMS content state init
    init() {
        self.title = ""
        self.description = ""
        self.notificationsCountText = ""
        self.readTime = ""
        self.isRead = false
        self.showReadUnreadIndicator = false
        self.sentAt = ""
        self.type = .undefined
        self.notificationType = ""
        self.notificationData = ""
    }
}
