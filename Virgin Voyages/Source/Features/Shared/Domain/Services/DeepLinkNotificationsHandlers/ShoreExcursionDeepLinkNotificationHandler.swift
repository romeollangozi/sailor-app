//
//  ShoreExcursionDeepLinkNotificationHandler.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/13/25.
//

import Foundation

struct ShoreExcursionDeepLinkNotificationHandler: DeepLinkNotificationHandlerProtocol {
    
    private let appCoordinator: CoordinatorProtocol
    private let notificationJSONDecoder: NotificationJSONDecoderProtocol
    
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         notificationJSONDecoder: NotificationJSONDecoderProtocol = NotificationJSONDecoder()) {
        
        self.appCoordinator = appCoordinator
        self.notificationJSONDecoder = notificationJSONDecoder
    }
    
    func handle(userStatus: UserApplicationStatus, type: String, payload: String) {
        
        switch type {
            
        case DeepLinkNotificationType.voyagesPaExperienceUpdateMeetingLocation.rawValue:
            
            if let remindNotificationData: ReminderNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: ReminderNotificationData.self) {
                
                let remind = remindNotificationData.toDomain()
                
                guard let date = createDate(from: remind.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }
            
        case DeepLinkNotificationType.arsCrewBookings.rawValue:
            
            if let arsNotificationData: ARSNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: ARSNotificationData.self) {
                
                let ars = arsNotificationData.toDomain()
                
                guard let date = createDate(from: ars.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }
            
        case DeepLinkNotificationType.travelpartyExcursionCancelled.rawValue:
            appCoordinator.executeCommand(HomeTabBarCoordinator.ShowNotificationMessagesFullScreenCoverCommand())
        case DeepLinkNotificationType.voyagesExcursionCancelled.rawValue:
            appCoordinator.executeCommand(HomeTabBarCoordinator.ShowNotificationMessagesFullScreenCoverCommand())
        case DeepLinkNotificationType.voyagesExcursionBooked.rawValue:
            
            if let voyageNotificationData: VoyageNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: VoyageNotificationData.self) {
                
                let voyage = voyageNotificationData.toDomain()
                
                guard let date = createDate(from: voyage.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }
            
        case DeepLinkNotificationType.travelpartyExcursionEdit.rawValue:
            
            if let travelPartyNotificationData: TravelPartyNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: TravelPartyNotificationData.self) {
                
                let travelParty = travelPartyNotificationData.toDomain()
                
                guard let date = createDate(from: travelParty.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }
            
        case DeepLinkNotificationType.portopenBookingAvailable.rawValue:
            
            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenDiscoverShorexListCommand())
            
        case DeepLinkNotificationType.remindActivityStartQuarterly.rawValue:
            
            if let remindNotificationData: ReminderNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: ReminderNotificationData.self) {
                
                let remind = remindNotificationData.toDomain()
                
                guard let date = createDate(from: remind.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }
            
        case DeepLinkNotificationType.travelpartyExcursionBooked.rawValue:
            
            if let travelPartyNotificationData: TravelPartyNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: TravelPartyNotificationData.self) {
                
                let travelParty = travelPartyNotificationData.toDomain()
                
                guard let date = createDate(from: travelParty.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }
            
        case DeepLinkNotificationType.remindActivityStartHourly.rawValue:
            
            if let remindNotificationData: ReminderNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: ReminderNotificationData.self) {
                
                let remind = remindNotificationData.toDomain()
                
                guard let date = createDate(from: remind.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
                
            }
            
        case
            DeepLinkNotificationType.voyagesPaExperienceUpdateMeetingTimelocation.rawValue,
            DeepLinkNotificationType.voyagesExperienceUpdateMeetingTimelocation.rawValue,
            DeepLinkNotificationType.voyagesRtExperienceUpdateMeetingTimelocation.rawValue,
            DeepLinkNotificationType.voyagesIetExperienceUpdateMeetingTimelocation.rawValue,
            DeepLinkNotificationType.voyagesNetExperienceUpdateMeetingTimelocation.rawValue,
            DeepLinkNotificationType.voyagesPaidHardClash.rawValue:
            
            navigateToMeAgendaSpecificDate(reminderNotificationData: payload)

        default:
            print("Unknown type")

        }
        
    }
    
    func navigateToMeAgendaSpecificDate(reminderNotificationData payload: String) {
        
        if let remindNotificationData: ReminderNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: ReminderNotificationData.self) {
            
            let remind = remindNotificationData.toDomain()
            
            guard let date = createDate(from: remind.currentDate) else {
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                return
            }
            
            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
        }
    }
}
