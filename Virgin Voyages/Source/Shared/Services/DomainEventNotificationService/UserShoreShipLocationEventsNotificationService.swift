//
//  UserShoreShipLocationEventsNotificationService.swift
//  Virgin Voyages
//
//  Created by TX on 6.8.25.
//

enum UserShoreShipLocationEventNotification: Hashable {
    case userDudChangeLocation(SailorLocation)
    case userDidSwitchFromShoreToShip

}

class UserShoreShipLocationEventsNotificationService: DomainNotificationService<UserShoreShipLocationEventNotification> {
    static let shared = UserShoreShipLocationEventsNotificationService()
}

