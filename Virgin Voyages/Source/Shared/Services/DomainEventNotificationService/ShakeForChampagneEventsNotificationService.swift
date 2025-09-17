//
//  ShakeForChampagneEventNotificationService.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 8/1/25.
//

import Foundation

enum ShakeForChampagneEventNotification: Hashable {
    case didDetectShakeForChampagneDelivered
}

final class ShakeForChampagneEventsNotificationService: DomainNotificationService<ShakeForChampagneEventNotification> {
    
    static let shared = ShakeForChampagneEventsNotificationService()
    
}
