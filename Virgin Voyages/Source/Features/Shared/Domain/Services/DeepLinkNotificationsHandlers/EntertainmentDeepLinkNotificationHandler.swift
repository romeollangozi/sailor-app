//
//  EntertainmentDeepLinkNotificationHandler.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 5/7/25.
//

import Foundation

struct EntertainmentDeepLinkNotificationHandler: DeepLinkNotificationHandlerProtocol {
    
    private let appCoordinator: CoordinatorProtocol
    private let notificationJSONDecoder: NotificationJSONDecoderProtocol
    
    init(appCoordinator: CoordinatorProtocol = AppCoordinator.shared,
         notificationJSONDecoder: NotificationJSONDecoderProtocol = NotificationJSONDecoder()) {
        
        self.appCoordinator = appCoordinator
        self.notificationJSONDecoder = notificationJSONDecoder
    }
    
    func handle(userStatus: UserApplicationStatus, type: String, payload: String) {

        switch type {

        case DeepLinkNotificationType.travelPartyPaidEventCancelled.rawValue:
            appCoordinator.executeCommand(HomeTabBarCoordinator.ShowNotificationMessagesFullScreenCoverCommand())

        case DeepLinkNotificationType.travelPartyPaidEventBooked.rawValue,
            DeepLinkNotificationType.travelPartyUnpaidEventIetBooked.rawValue,
            DeepLinkNotificationType.voyagesSpaCancelled.rawValue,
            DeepLinkNotificationType.voyagesSpaBooked.rawValue,
            DeepLinkNotificationType.travelPartyUnpaidEventNetBooked.rawValue:

            navigateToMeAgendaSpecificDate(travelPartyNotificationData: payload)

        case DeepLinkNotificationType.remindInventoryPaidEventsBeforeHalfHour.rawValue,
            DeepLinkNotificationType.remindInventoryUnpaidEventsBeforeHalfHour.rawValue,
            DeepLinkNotificationType.remindNonInventoryEventsBeforeHalfHour.rawValue,
            DeepLinkNotificationType.remindSpaBeforeHalfHour.rawValue:

            navigateToMeAgendaSpecificDate(reminderNotificationData: payload)


        default:
            print("Unknown type")
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

        func navigateToMeAgendaSpecificDate(travelPartyNotificationData payload: String) {
            if let travelPartyNotificationData: TravelPartyNotificationData = notificationJSONDecoder.decodeNotificationData(payload, as: TravelPartyNotificationData.self) {
                let travelParty =  travelPartyNotificationData.toDomain()
                guard let date = createDate(from: travelParty.currentDate) else {
                    appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeScreenCommand())
                    return
                }
                appCoordinator.executeCommand(HomeTabBarCoordinator.OpenMeAgendaSpecificDateCommand(date: date))
            }
        }
    }
}
