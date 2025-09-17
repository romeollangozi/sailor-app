//
//  MessageNotification.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 21.10.24.
//

import Foundation

enum NotificationType: String {
    case actionNotifications = "ActionNotifications"
    case statusBanners = "StatusBanners"
    case notifications = "Notifications"
    case urlNotifications = "URLNotifications"
    case undefined = "Undefined"
}

struct NotificationMessage: Identifiable, Equatable {
    var id: String
    var body: String
    var type: NotificationType
    var title: String
    var readTime: Date?
    var sentAt: Date?
    var isRead: Bool
    var notificationType: String
    var notificationData: String

    fileprivate static func isReadComputed(by readTime: Date?) -> Bool {
        guard let readTime, readTime.timeIntervalSince1970 != 0  else { return false }
        return readTime < Date.now
    }
}

//MARK: API Response Model to Domain Model

extension NotificationMessage {
    static func mapFromAPIDTO(response: GetMessagesRsponse.Notification, isRead: Bool? = nil) -> NotificationMessage {
        let readTime = response.Read_Time?.toDateFromMilliseconds()
        return .init(
            id: response.NotificationID.value,
            body: response.Notification_Body.value,
            type: .init(rawValue: response.type.value) ?? .undefined,
            title: response.Notification_Title.value,
            readTime: readTime ?? nil,
            sentAt: response.sentAt?.toDateFromMilliseconds() ?? nil,
            isRead: isRead ?? isReadComputed(by: readTime),
            notificationType: response.Notification_Type.value,
            notificationData: response.Notification_Data.value
        )
    }
}


