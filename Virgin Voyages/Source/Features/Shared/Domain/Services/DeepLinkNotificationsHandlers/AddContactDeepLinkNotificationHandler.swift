//
//  AddContactDeepLinkNotificationHandler.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 1.9.25.
//

import Foundation

struct AddContactDeepLinkNotificationHandler: DeepLinkNotificationHandlerProtocol {

	private let appCoordinator: CoordinatorProtocol
	private let notificationJSONDecoder: NotificationJSONDecoderProtocol

	init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
		 notificationJSONDecoder: NotificationJSONDecoderProtocol = NotificationJSONDecoder()) {

		self.appCoordinator = appCoordinator
		self.notificationJSONDecoder = notificationJSONDecoder
	}

	func handle(userStatus: UserApplicationStatus, type: String, payload: String) {
		switch type {
		case DeepLinkNotificationType.addContacts.rawValue:

			if let addContactNotificationData: AddContactNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: AddContactNotificationData.self) {

				let contact = addContactNotificationData.toDomain()

				appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMessengerContactsScreenDeepLinkCommand(contact: contact))
			}
		default:
			print("Unknown type")
		}
	}

}
