//
//  FirebasePushNotificationService.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 11.11.24.
//

import Firebase
import FirebaseMessaging
import UserNotifications
import UIKit

@Observable class FirebasePushNotificationService: NSObject, PushNotificationProviderProtocol, MessagingDelegate, UNUserNotificationCenterDelegate, UIApplicationDelegate {
 
    static let shared = FirebasePushNotificationService()
    private var savePushNotificationDeviceTokenUseCase: SavePushNotificationDeviceTokenUseCaseProtocol = SavePushNotificationDeviceTokenUseCase()
    private let notificationsEventsNotificationService: PushNotificationsEventNotificationService
    private let shakeForChampagneEventsNotificationService: ShakeForChampagneEventsNotificationService

    var latestNotification: PushNotificationModel?
    var userApplicationStatus: UserApplicationStatus?
    var getUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol
    var deepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol
    var showNotification: Bool = false
    var deviceToken: String = ""
    
    private init(getUserApplicationStatusUseCase: GetUserApplicationStatusUseCaseProtocol = GetUserApplicationStatusUseCase(),
                 notificationsEventsNotificationService: PushNotificationsEventNotificationService = .shared,
                 deepLinkNotificationDispatcher: DeepLinkNotificationDispatcherProtocol = DeepLinkNotificationDispatcher(),
                 shakeForChampagneEventsNotificationService: ShakeForChampagneEventsNotificationService = .shared
    ) {
        
        self.getUserApplicationStatusUseCase = getUserApplicationStatusUseCase
        self.notificationsEventsNotificationService = notificationsEventsNotificationService
        self.deepLinkNotificationDispatcher = deepLinkNotificationDispatcher
        self.shakeForChampagneEventsNotificationService = shakeForChampagneEventsNotificationService
        super.init()
        setupFirebase()
    }
    
    
    private func configureFirebase() {
        let info = Bundle.main.infoDictionary

        guard
            let apiKey = info?["FIREBASE_API_KEY"] as? String,
            let projectID = info?["FIREBASE_PROJECT_ID"] as? String,
            let appID = info?["FIREBASE_GOOGLE_APP_ID"] as? String,
            let gcmSenderID = info?["FIREBASE_GCM_SENDER_ID"] as? String,
            let bundleID = info?["FIREBASE_BUNDLE_ID"] as? String
        else {
            print("FirebasePushNotificationService - ConfigureFirebase Error: Missing required Firebase Info.plist keys.")
            return
        }

        let options = FirebaseOptions(googleAppID: appID, gcmSenderID: gcmSenderID)
        options.apiKey = apiKey
        options.projectID = projectID
        options.bundleID = bundleID
        
        // Optional fields added
        options.databaseURL = info?["FIREBASE_DATABASE_URL"] as? String
        options.storageBucket = info?["FIREBASE_STORAGE_BUCKET"] as? String
        options.clientID = info?["FIREBASE_CLIENT_ID"] as? String
        
        FirebaseApp.configure(options: options)
    }

    private func setupFirebase() {
        configureFirebase()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }
    
    func getCurrentAuthorizationStatus() async -> PushNotificationAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let status = PushNotificationAuthorizationStatus(from: settings.authorizationStatus)
                continuation.resume(returning: status)
            }
        }
    }
    
    func requestPushNotificationPermissions() async {
        let center = UNUserNotificationCenter.current()
        await withCheckedContinuation { continuation in
            center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
                guard let self = self else {
                    continuation.resume()
                    return
                }
                DispatchQueue.main.async {
                    self.handlePermissionResult(granted)
                    continuation.resume()
                }
            }
        }
    }
    
    func saveDeviceToken(_ deviceToken: String) {
        savePushNotificationDeviceTokenUseCase.execute(token: deviceToken)
    }

    private func handlePermissionResult(_ granted: Bool) {
        if granted {
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            print("User declined notifications")
        }
    }

    func didRegisterForRemoteNotificationsWithToken(token: Data) {
        Messaging.messaging().apnsToken = token
    }
    
    func didFailToRegisterForRemoteNotifications() {
        print("Failed to register for remote notifications")
    }
    
    func didRefreshDeviceToken(token: String) {
        deviceToken = token
        self.notificationsEventsNotificationService.publish(.deviceTokenHasbeenUpdated(token: token))
    }
    
    func preloadUserApplicationStatus() async {
        do {
            let status = try await getUserApplicationStatusUseCase.execute()
            self.userApplicationStatus = status
        } catch {
        }
    }
    
    func handleNotificationTap(notification: PushNotificationModel) async {
        if let status = userApplicationStatus {
            deepLinkNotificationDispatcher.dispatch(userStatus: status,
                                                    type: notification.notificationType,
                                                    data: notification.notificationData)
        } else {
            // If user is not loaded, wait to load userAppStatus, then Handle notification action again
            await preloadUserApplicationStatus()
            await handleNotificationTap(notification: notification)
        }
    }
}

// MARK: - MessagingDelegate for Firebase token handling
extension FirebasePushNotificationService {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let deviceToken = fcmToken else {
            print("FirebasePushNotificationService - Failed to get token.")
            return
        }
        // Save device token locally.
        saveDeviceToken(deviceToken)
        // Update service device token for any listener
        didRefreshDeviceToken(token: deviceToken)

    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String?) {
        guard let deviceToken = fcmToken else {
            print("FirebasePushNotificationService - Failed to get token after refresh.")
            return
        }
        // Save device token locally.
        saveDeviceToken(deviceToken)
        // Update service device token for any listener
        didRefreshDeviceToken(token: deviceToken)
    }
}


// MARK: - UNUserNotificationCenterDelegate for handling notifications
extension FirebasePushNotificationService {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification when the app is in the foreground.
        completionHandler([.sound])
        handleReceivedNotification(notification)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Show notification when the app comes from background.
        completionHandler()
        handleReceivedNotification(response.notification, isBackgroundNotification: true)
    }
    
    func handleReceivedNotification(_ notification: UNNotification, isBackgroundNotification: Bool = false) {
        // Get the notification content
        let content = notification.request.content
        let title = content.title
        let message = content.body
        
        let userInfo = notification.request.content.userInfo
        
        guard let notificationType: String = userInfo[String.notificationType] as? String,
              let notificationData: String = userInfo[String.notificationData] as? String
        else { return }
        
        let isShakeForChampagneNotification = [DeepLinkNotificationType.s4cChampagneOrdered.rawValue, DeepLinkNotificationType.s4cChampagneCancelled.rawValue, DeepLinkNotificationType.s4cChampagneDelivered.rawValue].contains(notificationType)

        let notificationModel = PushNotificationModel(
            title: title,
            message: message,
            notificationType: notificationType,
            notificationData: notificationData
        )

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if notificationType == DeepLinkNotificationType.s4cChampagneDelivered.rawValue {
                self.shakeForChampagneEventsNotificationService.publish(.didDetectShakeForChampagneDelivered)
            }

            self.latestNotification = notificationModel
            self.showNotification = !isBackgroundNotification && !isShakeForChampagneNotification

            if isBackgroundNotification {
                Task { [weak self] in
                    await self?.handleNotificationTap(notification: notificationModel)
                }
            }
        }
    }
}
