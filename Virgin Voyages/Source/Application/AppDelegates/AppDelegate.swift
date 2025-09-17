//
//  AppDelegate.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 8/19/24.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {

	let childAppDelegates: [UIApplicationDelegate] = [
		ApptentiveAppDelegate(),
		PushNotificationAppDelegate(),
        FacebookLoginAppDelegate(),
        DynaTraceAppDelegate(),
        QuantumMetricAppDelegate(),
        LocalizationAppDelegate(),
	]

	func application(_ application: UIApplication, didFinishLaunchingWithOptions 
					 launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		childAppDelegates.forEach({ let _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) })
		return true
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		childAppDelegates.forEach({ $0.applicationWillEnterForeground?(application) })
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		childAppDelegates.forEach({ $0.applicationDidEnterBackground?(application) })
	}

	func application(_ application: UIApplication, 
					 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		childAppDelegates.forEach({ $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) })
	}

	func application(_ application: UIApplication, 
					 didFailToRegisterForRemoteNotificationsWithError error: Error) {
		childAppDelegates.forEach({ $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error) })
	}
    
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

}
