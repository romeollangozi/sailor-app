//
//  PushNotificationAppDelegate.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/19/24.
//

import UIKit
import Foundation
import Firebase

class PushNotificationAppDelegate: NSObject, UIApplicationDelegate {

    // First Initialization of the Shared Push Notification Service
    var pushNotificationService: PushNotificationService = PushNotificationService(provider: FirebasePushNotificationService.shared)

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		return true
	}

	// MARK: Aplication Delegate - Handling Device Token
	func application(_ application: UIApplication,
					 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
		let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
		let token = tokenParts.joined()
		print("Device Token: \(token)")
        pushNotificationService.didRegisterForRemoteNotificationsWithToken(token: deviceToken)
	}

	func application(_ application: UIApplication, 
					 didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register for remote notifications with error: \(error)")
        pushNotificationService.didFailToRegisterForRemoteNotifications()
	}
}
