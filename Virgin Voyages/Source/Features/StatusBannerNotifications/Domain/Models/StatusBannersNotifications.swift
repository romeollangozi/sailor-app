//
//  StatusBannersNotifications.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/29/25.
//

import Foundation

struct StatusBannersNotifications: Hashable {
    let items: [StatusBannersNotificationItem]
    
    struct StatusBannersNotificationItem: Hashable, Identifiable {
        let id: String
        let type: String
        let data: String
        let title: String
        let description: String
        let isRead: Bool
        let createdAt: Date
        let isTappable: Bool
        let isDismissable: Bool
    }
    
}

extension StatusBannersNotifications {
    
    static func sample() -> StatusBannersNotifications {
        return StatusBannersNotifications(items: [.sample()])
    }
    
    static func empty() -> StatusBannersNotifications {
        return StatusBannersNotifications(items: [])
    }
    
    func copy(items: [StatusBannersNotificationItem]? = nil) -> StatusBannersNotifications {
        
        return StatusBannersNotifications(items: items ?? self.items)
        
    }
}


extension StatusBannersNotifications.StatusBannersNotificationItem {
    
    static func sample() -> StatusBannersNotifications.StatusBannersNotificationItem {
        .init(
            id: "75e15287-e544-44cf-87ca-cc0ca17bb78b",
            type: "notification.management",
            data: "{\"ORDER_ID\":\"cc821c43-cb6f-4a98-8f0f-4ca59efbf789\",\"ACTIVITY_CODE\":\"s4c.champagneOrdered\"}",
            title: "Free form notification for Sailor 05/01/2025",
            description: "Free form notification for Sailor 05/01/2025.",
            isRead: false,
            createdAt: Date(),
            isTappable: true,
            isDismissable: false
        )
    }
    
    
    func copy(
        id: String? = nil,
        type: String? = nil,
        data: String? = nil,
        title: String? = nil,
        description: String? = nil,
        isRead: Bool? = nil,
        createdAt: Date? = nil,
        isTappable: Bool? = nil,
        isDismissable: Bool? = nil
    ) -> StatusBannersNotifications.StatusBannersNotificationItem {
        return StatusBannersNotifications.StatusBannersNotificationItem(
            id: id ?? self.id,
            type: type ?? self.type,
            data: data ?? self.data,
            title: title ?? self.title,
            description: description ?? self.description,
            isRead: isRead ?? self.isRead,
            createdAt: createdAt ?? self.createdAt,
            isTappable: isTappable ?? self.isTappable,
            isDismissable: isDismissable ?? self.isDismissable
        )
    }
}
