//
//  FolioDeepLinkNotificationHandler.swift
//  Virgin Voyages
//
//  Created by Pajtim on 14.8.25.
//

import Foundation

struct FolioDeepLinkNotificationHandler: DeepLinkNotificationHandlerProtocol {

    private let appCoordinator: CoordinatorProtocol
    private let notificationJSONDecoder: NotificationJSONDecoderProtocol

    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         notificationJSONDecoder: NotificationJSONDecoderProtocol = NotificationJSONDecoder()) {

        self.appCoordinator = appCoordinator
        self.notificationJSONDecoder = notificationJSONDecoder
    }

    func handle(userStatus: UserApplicationStatus, type: String, payload: String) {
        switch type {
        case DeepLinkNotificationType.folioSailorCash.rawValue:
            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenWalletFromMeCommand())
        case DeepLinkNotificationType.folioSailorPayer.rawValue:
            appCoordinator.executeCommand(HomeTabBarCoordinator.ShowNotificationMessagesFullScreenCoverCommand())
        default:
            print("Unknown type")
        }
    }

}
