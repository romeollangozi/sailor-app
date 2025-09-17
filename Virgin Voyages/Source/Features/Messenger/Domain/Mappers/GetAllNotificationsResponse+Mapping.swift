//
//  Notifications+Mapping.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 25.5.25.
//

import Foundation

extension GetAllNotificationsResponse {
	func toDomain() -> Notifications {
		.init(items: self.items?.map({$0.toDomain()}) ?? [], hasMore: self.hasMore.value)
	}
}

extension GetAllNotificationsResponse.NotificationItem {
	func toDomain() -> Notifications.NotificationItem {
		.init(id: self.id.value,
              type: self.type.value,
			  data: self.data.value,
			  title: self.title.value,
			  description: self.description.value,
			  isRead: self.isRead.value,
			  createdAt: Date.fromISOString(string: self.createdAt),
              isTappable: self.isTappable.value)
	}
}
