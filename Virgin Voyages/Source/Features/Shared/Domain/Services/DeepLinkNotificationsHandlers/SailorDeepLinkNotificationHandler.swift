//
//  SailorDeepLinkNotificationHandler.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/22/25.
//

import Foundation
import UIKit

struct SailorDeepLinkNotificationHandler: DeepLinkNotificationHandlerProtocol {
    
    private let appCoordinator: CoordinatorProtocol
    private let notificationJSONDecoder: NotificationJSONDecoderProtocol
    private let webUrlLauncher: WebUrlLauncherProtocol
    
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         notificationJSONDecoder: NotificationJSONDecoderProtocol = NotificationJSONDecoder(),
         webUrlLauncher: WebUrlLauncherProtocol = WebUrlLauncher()) {
        
        self.appCoordinator = appCoordinator
        self.notificationJSONDecoder = notificationJSONDecoder
        self.webUrlLauncher = webUrlLauncher
    }
    
    func handle(userStatus: UserApplicationStatus, type: String, payload: String) {
        
        switch type {
            
        case DeepLinkNotificationType.sailorReviewAsk.rawValue:
            
            if let sailorNotifiactionData: SailorNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: SailorNotificationData.self) {
                
                let sailorData = sailorNotifiactionData.toDomain()
                
                if let url = URL(string: sailorData.externalUrl) {
                    if UIApplication.shared.canOpenURL(url) {
                        
                        DispatchQueue.main.async {
                            webUrlLauncher.open(url: url)
                        }
                        
                    }
                }
                
            }
            
        case DeepLinkNotificationType.notificationManagement.rawValue:

            print("No navigation")
            
            
        default:
            print("Unknown type")
        }
        
    }
}
