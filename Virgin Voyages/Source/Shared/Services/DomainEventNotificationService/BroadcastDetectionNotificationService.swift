//
//  BroadcastDetectionNotificationService.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 9/10/25.
//

import Foundation

enum BroadcastDetectionNotification: Hashable {
    case didDetectPeripheralPoweredOn
}

final class BroadcastDetectionNotificationService: DomainNotificationService<BroadcastDetectionNotification> {
    
    static let shared = BroadcastDetectionNotificationService()
    
}
