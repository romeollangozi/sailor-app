//
//  MockFriendsEventsNotificationService.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 10.6.25.
//

import Foundation

@testable import Virgin_Voyages

final class MockFriendsEventsNotificationService: FriendsEventsNotificationService {
	private var notfications: [FriendsEventNotification] = []
	
	override func publish(_ event: FriendsEventNotification) {
		notfications.append(event)
	}
}
