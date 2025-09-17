//
//  ShakeForChampagneDeepLinkNotificationHandler.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 7/30/25.
//

import Foundation

struct ShakeForChampagneDeepLinkNotificationHandler: DeepLinkNotificationHandlerProtocol {
    
    private let appCoordinator: CoordinatorProtocol
    private let notificationJSONDecoder: NotificationJSONDecoderProtocol
    
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         notificationJSONDecoder: NotificationJSONDecoderProtocol = NotificationJSONDecoder()) {
        
        self.appCoordinator = appCoordinator
        self.notificationJSONDecoder = notificationJSONDecoder
    }
    
    func handle(userStatus: UserApplicationStatus, type: String, payload: String) {
        
        switch type {
            
        case DeepLinkNotificationType.s4cChampagneOrdered.rawValue:
            
            if let shakeForChampagneNotificationData: ShakeForChampagneNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: ShakeForChampagneNotificationData.self) {
                
                let shakeForChampagneNotification = shakeForChampagneNotificationData.toDomain()
                
                self.appCoordinator.executeCommand(HomeTabBarCoordinator.ShowShakeForChampagneAnimationFullScreenCommand(orderId: shakeForChampagneNotification.ORDER_ID))
            }
            
        case DeepLinkNotificationType.s4cChampagneDelivered.rawValue:
            
            if let shakeForChampagneNotificationData: ShakeForChampagneNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: ShakeForChampagneNotificationData.self) {
                
                let shakeForChampagneNotification = shakeForChampagneNotificationData.toDomain()
                
                self.appCoordinator.executeCommand(HomeTabBarCoordinator.ShowShakeForChampagneAnimationFullScreenCommand(orderId: shakeForChampagneNotification.ORDER_ID))
            }
            
        case DeepLinkNotificationType.s4cChampagneCancelled.rawValue:
            
            if let shakeForChampagneNotificationData: ShakeForChampagneNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: ShakeForChampagneNotificationData.self) {
                
                let shakeForChampagneNotification = shakeForChampagneNotificationData.toDomain()
                
                self.appCoordinator.executeCommand(HomeTabBarCoordinator.ShowShakeForChampagneAnimationFullScreenCommand(orderId: shakeForChampagneNotification.ORDER_ID))
            }
            
        default:
            print("Unknown type")
        }
        
    }
    
}
