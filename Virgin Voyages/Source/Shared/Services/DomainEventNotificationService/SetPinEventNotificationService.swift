//
//  SetPinEventNotificationService.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 22.7.25.
//

import Foundation

enum SetPinNotification: Hashable {
	case success
	case error
}

protocol SetPinEventNotificationServiceProtocol {
	func notify(_ event: SetPinNotification)
}

final class SetPinEventNotificationService: DomainNotificationService<SetPinNotification> {
	static let shared = SetPinEventNotificationService()
}

extension SetPinEventNotificationService: SetPinEventNotificationServiceProtocol {
	func notify(_ event: SetPinNotification) {
		publish(event)
	}
}
