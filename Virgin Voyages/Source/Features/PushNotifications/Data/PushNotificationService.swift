//
//  PushNotificationService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/19/24.
//

import UIKit
import Foundation
import UserNotifications
import Firebase

protocol PushNotificationServiceProtocol {
    
    func didRegisterForRemoteNotificationsWithToken(token: Data)
    func didRefreshDeviceToken(token: String)
    func didFailToRegisterForRemoteNotifications()
    
    var latestNotification: PushNotificationModel? { get set }
    var showNotification: Bool { get set }
    var deviceToken: String { get }
    
    func getCurrentAuthorizationStatus() async -> PushNotificationAuthorizationStatus
    func requestPushNotificationPermissions() async
}

@Observable class PushNotificationService: PushNotificationServiceProtocol {
    
    private var provider: PushNotificationProviderProtocol
    
    init(provider: PushNotificationProviderProtocol) {
        self.provider = provider
    }
    
    func didRegisterForRemoteNotificationsWithToken(token: Data) {
        provider.didRegisterForRemoteNotificationsWithToken(token: token)
    }
    
    func didFailToRegisterForRemoteNotifications() {
        provider.didFailToRegisterForRemoteNotifications()
    }
    
    var latestNotification: PushNotificationModel? {
        get { provider.latestNotification }
        set { provider.latestNotification = newValue }
    }
    
    var showNotification: Bool {
        get { provider.showNotification }
        set { provider.showNotification = newValue }
    }
    
    func getCurrentAuthorizationStatus() async -> PushNotificationAuthorizationStatus {
        await provider.getCurrentAuthorizationStatus()
    }
    
    func requestPushNotificationPermissions() async {
        await provider.requestPushNotificationPermissions()
    }
    
    func didRefreshDeviceToken(token: String) {
        provider.didRefreshDeviceToken(token: token)
    }
    
    var deviceToken: String {
        provider.deviceToken
    }
}
