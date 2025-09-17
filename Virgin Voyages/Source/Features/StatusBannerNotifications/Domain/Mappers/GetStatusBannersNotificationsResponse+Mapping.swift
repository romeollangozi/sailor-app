//
//  GetStatusBannersNotificationsResponse+Mapping.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/29/25.
//

import Foundation

extension GetStatusBannersNotificationsResponse {
    func toDomain() -> StatusBannersNotifications {
        .init(items: self.items?.map({$0.toDomain()}) ?? [])
    }
}

extension GetStatusBannersNotificationsResponse.StatusBannerNotificationItem {
    
    func toDomain() -> StatusBannersNotifications.StatusBannersNotificationItem {
        .init(id: self.id.value,
              type: self.type.value,
              data: self.data.value,
              title: self.title.value,
              description: self.description.value,
              isRead: self.isRead.value,
              createdAt: Date.fromISOString(string: self.createdAt),
              isTappable: self.isTappable.value,
              isDismissable: self.isDismissable.value)
    }
}
