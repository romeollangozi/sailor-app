//
//  RTSDeepLinkNotificationHandler.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/16/25.
//

import Foundation

struct RTSDeepLinkNotificationHandler: DeepLinkNotificationHandlerProtocol {
    
    private let appCoordinator: CoordinatorProtocol
    private let notificationJSONDecoder: NotificationJSONDecoderProtocol
    
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         notificationJSONDecoder: NotificationJSONDecoderProtocol = NotificationJSONDecoder()) {
        
        self.appCoordinator = appCoordinator
        self.notificationJSONDecoder = notificationJSONDecoder
    }
    
    func handle(userStatus: UserApplicationStatus, type: String, payload: String) {
        
        switch type {
            
        case DeepLinkNotificationType.rtsFourDaysAfterLogin.rawValue:
            
            appCoordinator.executeCommand(HomeDashboardCoordinator.ShowReadyToSailFullScreenCoverCommand(taskDetail: nil, sailor: nil))
            
        case DeepLinkNotificationType.rtsSevenDaysBeforeVoyage.rawValue:
            
            appCoordinator.executeCommand(HomeDashboardCoordinator.ShowReadyToSailFullScreenCoverCommand(taskDetail: nil, sailor: nil))
            
        case DeepLinkNotificationType.rtsOneDayAfterTask.rawValue:

            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenHomeDashboardScreenCommand())

        default:
            print("Unknown type")
        }
        
    }
    
}
