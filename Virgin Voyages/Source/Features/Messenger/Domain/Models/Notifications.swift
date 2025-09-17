//
//  Notifications.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 25.5.25.
//

import Foundation

struct Notifications: Hashable {
	let items: [NotificationItem]
	let hasMore: Bool
	
	struct NotificationItem: Hashable, Identifiable {
		let id: String
		let type: String
		let data: String
		let title: String
		let description: String
		let isRead: Bool
		let createdAt: Date
        let isTappable: Bool
		var timeAgo: String {
			return createdAt.timeAgoDisplay()
		}
	}
}

extension Notifications {
	static func sample() -> Notifications {
		return Notifications(
			items: [
				.sample()
			],
			hasMore: false
		)
	}

	static func empty() -> Notifications {
		return Notifications(items: [], hasMore: false)
	}

	func copy(
		items: [NotificationItem]? = nil,
		hasMore: Bool? = nil
	) -> Notifications {
		return Notifications(
			items: items ?? self.items,
			hasMore: hasMore ?? self.hasMore
		)
	}
}


extension Notifications.NotificationItem {
	static func sample() -> Notifications.NotificationItem {
		.init(
			id: "75e15287-e544-44cf-87ca-cc0ca17bb78b",
			type: "notification.management",
			data: "{}",
			title: "Free form notification for Sailor 05/01/2025",
			description: "Free form notification for Sailor 05/01/2025.",
			isRead: false,
            createdAt: Date(),
            isTappable: true
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
        isTappable: Bool? = nil
	) -> Notifications.NotificationItem {
		return Notifications.NotificationItem(
			id: id ?? self.id,
			type: type ?? self.type,
			data: data ?? self.data,
			title: title ?? self.title,
			description: description ?? self.description,
			isRead: isRead ?? self.isRead,
			createdAt: createdAt ?? self.createdAt,
            isTappable: isTappable ?? self.isTappable
		)
	}
}
