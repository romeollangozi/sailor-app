//
//  PushNotificationProviderProtocol.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/19/24.
//

import Foundation
import UserNotifications

protocol PushNotificationProviderProtocol {
    
    func didRegisterForRemoteNotificationsWithToken(token: Data)
    func didFailToRegisterForRemoteNotifications()
    func didRefreshDeviceToken(token: String)

    var latestNotification: PushNotificationModel? { get set }
    var showNotification: Bool { get set }
    
    func getCurrentAuthorizationStatus() async -> PushNotificationAuthorizationStatus
    func requestPushNotificationPermissions() async
    func handleReceivedNotification(_ notification: UNNotification, isBackgroundNotification: Bool)
    
    func saveDeviceToken(_ deviceToken: String)
    var deviceToken: String { get }
}
