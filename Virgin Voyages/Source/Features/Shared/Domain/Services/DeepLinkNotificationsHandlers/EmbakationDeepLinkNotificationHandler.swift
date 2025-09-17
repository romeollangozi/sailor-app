//
//  EmbakationDeepLinkNotificationHandler.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/14/25.
//

import Foundation

struct EmbakationDeepLinkNotificationHandler: DeepLinkNotificationHandlerProtocol {
    
    private let appCoordinator: CoordinatorProtocol
    private let notificationJSONDecoder: NotificationJSONDecoderProtocol
    
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         notificationJSONDecoder: NotificationJSONDecoderProtocol = NotificationJSONDecoder()) {
        
        self.appCoordinator = appCoordinator
        self.notificationJSONDecoder = notificationJSONDecoder
    }
    
    func handle(userStatus: UserApplicationStatus, type: String, payload: String) {
        
        switch type {
            
        case DeepLinkNotificationType.guestTrackablePickup.rawValue:
            
            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenHomeDashboardScreenCommand())
            
        case DeepLinkNotificationType.rtsCompleteSailingday.rawValue:
            
            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenHomeDashboardScreenCommand())
            
        case DeepLinkNotificationType.rtsIncompleteHealthQuizSailingDay.rawValue:
            
            appCoordinator.executeCommand(HomeDashboardCoordinator.OpenHealthCheckLandingFullScreenCommand())
            
        case DeepLinkNotificationType.rtsIncompleteSailingday.rawValue:
            
            appCoordinator.executeCommand(HomeDashboardCoordinator.ShowReadyToSailFullScreenCoverCommand(taskDetail: nil, sailor: nil))
            

        case DeepLinkNotificationType.sailorMusterVideoNotWatched.rawValue,
            DeepLinkNotificationType.guestPostembarkationSafetyInstructions.rawValue:

            appCoordinator.executeCommand(HomeTabBarCoordinator.ShowMusterDrillFullScreenCommand(shouldRemainOpenAfterUserHasWatchedSafteyVideo: true))

        case DeepLinkNotificationType.aciActiveboardingroupEmbarkday.rawValue,
            DeepLinkNotificationType.acisupervisorActiveboardingroupEmbarkday.rawValue:
            appCoordinator.executeCommand(HomeTabBarCoordinator.ShowNotificationMessagesFullScreenCoverCommand())

        default:
            print("Unknown type")
        }
    }
}
