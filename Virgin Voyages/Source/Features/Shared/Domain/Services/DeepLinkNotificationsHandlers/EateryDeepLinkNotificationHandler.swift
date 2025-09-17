//
//  EateryDeepLinkNotificationHandler.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/15/25.
//

import Foundation

struct EateryDeepLinkNotificationHandler: DeepLinkNotificationHandlerProtocol {
    
    private let appCoordinator: CoordinatorProtocol
    private let notificationJSONDecoder: NotificationJSONDecoderProtocol
    
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         notificationJSONDecoder: NotificationJSONDecoderProtocol = NotificationJSONDecoder()) {
        
        self.appCoordinator = appCoordinator
        self.notificationJSONDecoder = notificationJSONDecoder
    }
    
    func handle(userStatus: UserApplicationStatus, type: String, payload: String) {
        
        switch type {
        
        case DeepLinkNotificationType.remindDinningStartHalf.rawValue:
            
            if let reminderNotificationData: ReminderNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: ReminderNotificationData.self) {
                
                let reminder = reminderNotificationData.toDomain()
                
                guard let date = createDate(from: reminder.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
                //                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeEateryReceiptCommand(appointmentId: reminder.appointmentId))
            }
            
            
        case DeepLinkNotificationType.travelpartyDinningCancelled.rawValue:
            
            appCoordinator.executeCommand(HomeTabBarCoordinator.ShowNotificationMessagesFullScreenCoverCommand())
            
        case DeepLinkNotificationType.travelpartyDinningBooked.rawValue:
            

            if let travelpartyNotificationData: TravelPartyNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: TravelPartyNotificationData.self) {
                
                let travelparty = travelpartyNotificationData.toDomain()
                
                guard let date = createDate(from: travelparty.currentDate) else {
                    
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }

            
        case DeepLinkNotificationType.travelpartyDinningEdit.rawValue:
            
            if let travelpartyNotificationData: TravelPartyNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: TravelPartyNotificationData.self) {
                
                let travelparty = travelpartyNotificationData.toDomain()
                
                guard let date = createDate(from: travelparty.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }
                        
        case DeepLinkNotificationType.voyagesDinningEdit.rawValue:
            
            if let voyageNotificationData: VoyageNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: VoyageNotificationData.self) {
                
                let voyage = voyageNotificationData.toDomain()
                
                guard let date = createDate(from: voyage.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }
                        
        case DeepLinkNotificationType.voyagesDinningCancelled.rawValue:
            
            appCoordinator.executeCommand(HomeTabBarCoordinator.ShowNotificationMessagesFullScreenCoverCommand())
            
        case DeepLinkNotificationType.voyagesDinningBooked.rawValue:
            
            if let voyageNotificationData: VoyageNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: VoyageNotificationData.self) {
                
                let voyage = voyageNotificationData.toDomain()
                
                guard let date = createDate(from: voyage.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }
            
        default:
            print("Unknown type")
        }
    }
    
}
